class ProductsController < ApplicationController
  # GET /products
  def index
    result = Products::IndexService.new(index_params).call

    page = index_params[:page].to_i > 0 ? index_params[:page].to_i : 1
    per_page = index_params[:per_page].to_i > 0 ? index_params[:per_page].to_i : 20
    render json: {
      items: result[:items],
      meta: {
        total_count: result[:total_count],
        page: page,
        per_page: per_page,
        total_pages: (result[:total_count].to_f / per_page).ceil
      }
    }
  end

  # GET /products/1
  def show
    product = Products::ShowService.new(params[:id]).call
    render json: product
  end

  private
  def index_params
    params.permit(:category, :sort, :page, :per_page)
  end
end
