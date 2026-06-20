module Products
  class ProductRepository
    def list(params)
      scope = Product.all

      scope = filter_by_category(scope, params[:category])
      total_count = scope.count
      scope = apply_sort(scope, params[:sort])
      scope = paginate(scope, params[:page], params[:per_page])

      {
        items: scope,
        total_count: total_count
      }
    end

    def find(id)
      Product.find(id)
    end

    def create(params)
      Product.create!(params)
    end

    def update(id, params)
      product = Product.find(id)
      product.update!(params)
      product
    end

    def destroy(id)
      product = Product.find(id)
      product.destroy!
    end

    private
    def filter_by_category(scope, category)
      return scope if category.blank?
      scope.where(category: category)
    end

    def apply_sort(scope, sort)
      case sort
      when "rating"
        scope.order(rating: :desc)
      when "price_asc"
        scope.order(price: :asc)
      when "price_desc"
        scope.order(price: :desc)
      when "newest"
        scope.order(created_at: :desc)
      else
        scope.order(id: :asc)
      end
    end

    def paginate(scope, page, per_page)
      page = page.to_i > 0 ? page.to_i : 1
      per_page = per_page.to_i > 0 ? per_page.to_i : 20
      per_page = 100 if per_page > 100
      scope.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
