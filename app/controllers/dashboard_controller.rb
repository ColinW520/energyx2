class DashboardController < ApplicationController
  def show
    @p_data = Submission.where(submissions: {created_at: 1.month.ago..Time.now}).joins(:participant).group("participants.name").count.sort_by {|k,v| v}.reverse
    @page_data = Ahoy::Event.where(user_id: nil).where(time: 1.month.ago..Time.now).group(:name).count.sort_by {|k,v| v}.reverse
    @city_data = Visit.group(:city).where(user_id: nil).where.not(city: nil).where(started_at: 1.month.ago..Time.now).count.sort_by {|k,v| v}.reverse
  end
end
