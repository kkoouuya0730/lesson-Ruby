class PostsController < ApplicationController
  before_action :set_post

  # GET /posts
  def index
    posts = Posts::IndexService.new(index_params).call
    render json: posts
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
    post = Posts::DestroyService.new(params[:id]).call
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
    params.permit(:user_id, :keyword)
  end
end
