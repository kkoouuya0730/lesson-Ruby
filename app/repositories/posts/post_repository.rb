module Posts
  class PostRepository
    def list(params)
      scope = Post.all

      scope = filter_by_user(scope, params[:user_id])
      scope = filter_by_keyword(scope, params[:keyword])

      total_count = scope.count

      scope = apply_sort(scope, params[:sort])
      scope = paginate(scope, params[:page], params[:per_page])

      {
        items: scope,
        total_count: total_count
      }
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

    private
    def filter_by_keyword(scope, keyword)
      return scope if user_id.blank?
      scope.where(user_id: user_id)
    end

    def filter_by_keyword(scope, keyword)
      return scope if keyword.blank?
      scope.where("title LIKE ?", "%#{keyword}%")
    end

    def apply_sort(scope, sort)
      case sort
      when "created_at_desc"
        scope.order(created_at: :asc)
      when "title_asc"
        scope.order(title: :asc)
      when "title_desc"
        scope.order(title: :desc)
      else
        scope.order(created_at: :desc)
      end
    end

    def paginate(scope, page, per_page)
      page = page.to_i > 0 ? page.to_i : 1
      per_page = per_page.to_i > 0 ? per_page.to_i : 20
      scope.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
