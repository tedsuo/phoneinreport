class ReportController < ApplicationController

  def index
    if params[:sort] == "votes"
      order = "count(votes.id) DESC"
    else
      order = "reports.created_at DESC"
    end
    @reports = Report.find(:all,
      :conditions => ["file_status = ? OR file_status = ?", "tagged", "tagged_and_geocoded"],
      :include =>[:voice_mail],
      :joins => 'LEFT JOIN votes ON votes.report_id = reports.id',
      :order => order,
      :group => 'reports.id'
    )
  end

  def show
    @report = Report.find params[:id]
  end

  def feed 
    @reports = @campaign.reports.find(:all, 
      :include =>:voice_mail, 
      :conditions => ["file_status = ? OR file_status = ?", "tagged", "tagged_and_geocoded"],
      :order => 'reports.created_at DESC'
    )
    respond_to do |format|
      format.xml do
        @reports_xml = @reports.to_xml(:methods => [:voice_mail_url], 
            :except => [:phone_city, :phone_state, :reporter_email])
        render :xml => @reports_xml
      end
      format.json do
        @reports_json = @reports.to_json(:methods => [:voice_mail_url], 
            :except => [:phone_city, :phone_state, :reporter_email])
        render :json => @reports_json
      end
    end
  end

end
