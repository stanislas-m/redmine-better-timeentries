class TimeentriesController < ApplicationController
  unloadable


  def index
    working_hours_per_day = 8
  	@projects = Project.visible.sorted
    @users = User.active.sorted

    @now = Time.now

    if params[:user].present?
      @user = User.where(:login => params[:user]).first
      if @user == nil
        render_404
      end
    else
      @user = User.current
    end

    if params[:month].present?
      @now = @now.change(month: params[:month])
    end

    if params[:year].present?
      @now = @now.change(year: params[:year])
    end

    @show_non_imputed = params[:show_non_imputed].present?
  	
  	first_day = @now.change(day: 1, hour: 0, minute: 1)
  	@days_in_month = Time.days_in_month(@now.month)
  	last_day = @now.change(day: @days_in_month, hour: 0, minute: 1)
    day_range = first_day..last_day

    sum_query = "round(hours / " + working_hours_per_day.to_s + " / 0.25, 2)* 0.25"
  	@projects_entries = TimeEntry.group(:project_id).where(:user => @user, :spent_on => day_range).sum(sum_query)
  	@time_entries = TimeEntry.group("day(spent_on)", :project_id).where(:user => @user, :spent_on => day_range).sum(sum_query)
    @time_entries_full = TimeEntry.group("day(spent_on)", :project_id).where(:user => @user, :spent_on => day_range).sum("hours")
  	@global_sum = TimeEntry.where(:user => @user, :spent_on => day_range).sum("hours / 8")
    @day_entries = TimeEntry.group("day(spent_on)").where(:user => @user, :spent_on => day_range).sum(sum_query)

    respond_to do |format|
      format.html {
        render :layout => !request.xhr?
      }
      format.csv {
        send_data([], :type => 'text/csv; header=present', :filename => 'imputations-'+@user.login+'-'+@now.month.to_s+'_'+@now.year.to_s+'.csv')
      }
    end
  end

  private

  def imputations_to_csv()

  end
end
