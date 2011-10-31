class Admin::ReportsController < AdminController
  active_scaffold :report do |config|
    config.columns.add :phone
    config.list.columns = [:created_at, :event_id, :file_status, :phone, 
        :voice_mail, :latitude, :longitude, :city, :state]
    config.update.columns = [:voice_mail, :created_at, :file_status, 
        :reporter_name, :phone, :event_id, :city, :state,:description, :latitude, :longitude, :notes]
    config.list.sorting = [{:file_status => :asc}, {:created_at => :desc}]
    config.show.columns = [:voice_mail, :created_at, :file_status, 
        :reporter_name, :phone, :event_id, :city, :state, :latitude, :longitude, :notes]
  	config.actions.exclude :create

    config.columns[:phone].sort_by :sql => "voice_mails.phone"

    config.columns[:file_status].label = "Report status"
    config.columns[:reporter_name].label = "Person's name"
  end

  def conditions_for_collection
    ['campaign_id = ?', @campaign.id]
  end
end
