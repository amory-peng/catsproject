class CatRentalRequestsController < ApplicationController

  def new
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create

    @cats = Cat.all
    @cat_rental = CatRentalRequest.new(cat_rental_params)

    if @cat_rental.save
      redirect_to cat_url(@cat_rental.cat)
    else
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find_by(id: params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat[:id])
  end

  def deny
    @request = CatRentalRequest.find_by(id: params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat[:id])
  end

  def cat_rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
