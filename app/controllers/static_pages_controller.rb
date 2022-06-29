class StaticPagesController < ApplicationController
  def home
    @bikes = Bike.order_by_newest.limit(9)
  end

  def help
    if params[:role] == 'lessor'
      render action: "lessor_help"
    else
      render action: "renter_help"
    end
  end
end
