class CalendarsController < ApplicationController
  before_action :logged_in_user
  before_action :load_bike
  layout :user_layout

  def index
    @calendars = Calendar.load_calendar_by_month(params[:month]).includes(:bike).as_json(include: :bike)
    respond_to do |format|
      format.html
      format.json { render json: { calendars: @calendars } }
    end
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(calendar_params)
    if @calendar.save
      flash[:success] = "Add new calendar successfully."
      redirect_to calendars_path, status: 303
    else
      render :new, status: 303
    end
  end

  private

    def calendar_params
      params.require(:calendar).permit(:start_day, :end_day, :bike_id)
    end

    def load_bike
      @bikes = Bike.find_by_status_available_correct_user(@current_user)
    end
end
