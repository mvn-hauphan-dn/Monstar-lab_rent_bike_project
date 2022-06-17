class CalendarsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :destroy
  before_action :logged_in_user
  before_action :load_bike, only: :new
  before_action :user_lessor?, only: :new
  before_action :correct_bike?, only: :create
  layout :user_layout

  def index
    @calendars = Calendar.joins(:bike).where(bikes: { user_id: @current_user.id }).load_calendar_by_month(params[:month], params[:year]).includes(:bike).as_json(include: :bike)
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

  def destroy
    Calendar.joins(:bike).where(bikes: { user_id: @current_user.id }).find(params[:id]).destroy
    flash[:success] = "Calendar was deleted"
    redirect_to calendars_path, status: 303
  end

  private

    def user_lessor?
      redirect_to calendars_path unless @current_user.lessor?
    end

    def correct_bike?
      bike = Bike.find(params[:bike_id])
      redirect_to calendars_path unless @current_user == bike.user
    end

    def calendar_params
      params.require(:calendar).permit(:start_day, :end_day, :bike_id)
    end

    def load_bike
      bikes = Bike.find_by_status_available_correct_user(@current_user)
      @bikes = bikes.map do |bike|
                 bike.name = bike.name + ' | ' + bike.license_plates
                 bike
               end
    end
end
