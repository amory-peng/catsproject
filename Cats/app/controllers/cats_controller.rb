class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])
    @cat_rental_requests = @cat.cat_rental_requests
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      # render json: @cat
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find_by(id: params[:id])
    render :edit
  end

  def update
    @cat = Cat.find_by(id: params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def approve
    @cat = Cat.find_by(id: params[:id])
    @cat.approve!
  end

  def deny
    @cat = Cat.find_by(id: params[:id])
    @cat.deny!
  end

  def cat_params
    params.require(:cat).permit(:color, :name, :description, :sex, :birth_date)
  end


end
