class ProductsController < ApplicationController

   def index
    @products = Product.order(:name).page params[:page]
    
    unless params[:search].blank?
    @products = @products.where("name LIKE %#{params[:search]}%") unless  params[:search].nil?
    end
    unless params[:product_type_id].blank?
      @pt = ProductType.find(params[:product_type_id])
      @products = @products.where(:product_type_id => @pt.id) unless params[:product_type_id].nil?
    end
    unless params[:brand_id].blank?
      @products = @products.where(:brand_id => params[:brand_id]) unless params[:brand_id].blank?
    end

   
  end

  def create

    pagination_args = {}
    pagination_args[:page] = params[:page] || 1
    pagination_args[:rows] = params[:rows] || 15

    if params[:q] && params[:q].present?
      @products = Product.standard_search(params[:q], pagination_args).results
    else
      @products = Product.where('deleted_at IS NULL OR deleted_at > ?', Time.zone.now )
    end

    render :template => '/products/index'
  end

  def show
    @product = Product.active.find(params[:id])
    form_info
  end

  private

  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end
end
