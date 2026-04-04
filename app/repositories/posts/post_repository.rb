module Posts
  class PostRepository
    def list(params)
      scope = Post.all

      if params[:user_id]
        scope = scope.where(user_id: params[:user_id])
      end

      if params[:keyword]
        scope = scope.where("title LIKE ?", "%#{params[:keyword]}%")
      end
      
      scope = scope.order(created_at: :desc)

      scope
    end

    def find(id)
      Post.find(id)
    end

    def create(params)
      Post.create!(params)
    end

    def update(id, params)
      post = Post.find(id)
      post.update!(params)
      post
    end

    def destroy(id)
      post = Post.find(id)
      post.destroy!
    end
  end
end