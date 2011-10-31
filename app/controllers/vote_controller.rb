class VoteController < ApplicationController
  def create
    report = Report.find params[:id]
    unless report.voted_already? request.remote_ip
      report.votes << Vote.new(:ip_address => request.remote_ip)
    end
    @votes_count = {:votes => report.votes.count};
    render :json => @votes_count;
  end
end
