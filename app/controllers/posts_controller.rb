class PostsController < ApplicationController
  # GET /posts
  def index
    result = Posts::IndexService.new(index_params).call

    page = index_params[:page].to_i > 0 ? index_params[:page].to_i : 1
    per_page = index_params[:page].to_i > 0 ? index_params[:page].to_i : 20
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

  # GET /posts/1
  def show
    post = Posts::ShowService.new(params[:id]).call
    render json: post
  end

  # POST /posts
  def create
    post = Posts::CreateService.new(post_params).call
    render json: post, status: :created
  end

  # PATCH/PUT /posts/1
  def update
    post = Posts::UpdateService.new(params[:id], post_params).call
    render json: post
  end

  # DELETE /posts/1
  def destroy
    Posts::DestroyService.new(params[:id]).call
    head :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [ :title, :body ])
  end

  def index_params
    params.permit(:user_id, :keyword, :sort, :page, :per_page)
  end
end
