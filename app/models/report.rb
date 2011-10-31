class Report < ActiveRecord::Base
  FILE_STATUS = %w(pending tagged unpublished junk) 
  COUNTRY_CODE_USA = CountryCodes.find_by_name('United States of America')[:numeric]

  belongs_to :campaign
  has_one :voice_mail, :dependent => :destroy
  has_one :reporter, :class_name => 'User'
  has_many :votes

  acts_as_mappable 
  before_validation :set_event, :geocode_address
  before_save :lookup_phone_locale, :update_status

  def address
    tagged? ? [self.city, self.state].join(', ') : nil
  end

  def country
    CountryCodes.find_by_numeric(self.country_code)[:name]
  end

  def voice_mail_url
    self.voice_mail.public_filename
  end

  def phone
    self.voice_mail.phone
  end

  def phone=(phone)
    self.voice_mail.update_attribute(:phone, phone)
  end

  def voted_already? remote_ip
    self.votes.each do |v|
      return true if remote_ip == v.ip_address
    end
    false
  end
  
  require 'open-uri'
  def lookup_phone_locale
    logger.error("In before_save: lookup_phone_locale")
    return true if (phone.to_i == 0) # only run this method if phone contains a number
    data = XmlSimple.xml_in(open(local_calling_guide_url(phone)).read)
    if data['prefixdata'] && data['prefixdata'][0] 
      self.phone_city = data['prefixdata'][0]['rc'][0] if data['prefixdata'][0]['rc']
      self.phone_state = data['prefixdata'][0]['region'][0] if data['prefixdata'][0]['region']
    end
    return true
  end

  def local_calling_guide_url(phone)
    return if (phone.to_i == 0) # only run this method if phone contains a number
    uri = "http://www.localcallingguide.com/xmlprefix.php?npa=NPA&nxx=NXX"
    uri.gsub("NPA", phone[0..2]).gsub("NXX", phone[3..5])
  end

  def tagged?
    (self.city? && self.state? && self.country_code?)
  end

  def geocoded?
    (self.latitude && self.latitude != 0.0 && self.longitude && self.longitude != 0.0)
  end

  def event_lat_lng
    if (@event['Latitude'].to_f == 0.0) || (@event['Longitude'].to_f == 0.0)
      [nil, nil]
    else
      [@event['Latitude'], @event['Longitude']]
    end
  end

protected

  def set_event 
    logger.error("In before_validation: set_event")
    (@event = campaign.events.detect {|e| e['key'] == self.event_id.to_s}) if self.event_id
    return true
  end

  def geocode_address
    logger.error("In before_validation: geocode_address")
    if @event
      self.latitude, self.longitude = event_lat_lng 
      return true if self.latitude && self.longitude
    end
    if tagged? 
      geo = GeoKit::Geocoders::MultiGeocoder.geocode(address)
      errors.add(:address, "Could not Geocode address") if !geo.success
      self.latitude, self.longitude = geo.success ? [geo.lat, geo.lng] : [nil, nil]
      return true
    end
    self.latitude, self.longitude = nil, nil
    return true
  end

  def update_status
    logger.error("In before_save: update_status")
    return true if (file_status == "junk" || file_status == "unpublished")
    self.file_status = case
      when tagged? && geocoded?: "tagged_and_geocoded"
      when tagged?: "tagged"
      else file_status
      end
    return true
  end
end
