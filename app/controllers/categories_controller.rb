class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update]
  before_action :require_user, except: [:index, :show]
  before_action :require_admin, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category was created."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = "The post was updated."
      redirect_to post_path
    else
      render :edit
    end
  end

  #strong parameters to expose the fields we want
  #to mass assign
  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find_by slug: params[:id]
  end

end
