require "test_helper"

class Products::ProductRepositoryTest < ActiveSupport::TestCase
  def setup
    @repository = Products::ProductRepository.new
  end

  test "パラメータがない場合、全ての件数が返る" do
    Product.create!(name: "Product1", description: "Desc1", price: 1000, category: "electronics")
    Product.create!(name: "Product2", description: "Desc2", price: 2000, category: "fashion")

    result = @repository.list({})

    assert_equal 2, result[:items].count
    assert_equal 2, result[:total_count]
  end

  test "categoryでフィルターされる" do
    Product.create!(name: "Phone", description: "Desc", price: 10000, category: "electronics")
    Product.create!(name: "Shirt", description: "Desc", price: 2000, category: "fashion")
    Product.create!(name: "Laptop", description: "Desc", price: 50000, category: "electronics")

    result = @repository.list({ category: "electronics" })

    assert_equal 2, result[:items].count
    assert_equal 2, result[:total_count]
    assert result[:items].all? { |p| p.category == "electronics" }
  end

  test "categoryが空の時に全件返る" do
    Product.create!(name: "Product1", description: "Desc", price: 1000, category: "electronics")
    Product.create!(name: "Product2", description: "Desc", price: 2000, category: "fashion")

    result = @repository.list({ category: "" })

    assert_equal 2, result[:items].count
  end

  test "categoryが一致しなかったときに0件になる" do
    Product.create!(name: "Product1", description: "Desc", price: 1000, category: "electronics")
    Product.create!(name: "Product2", description: "Desc", price: 2000, category: "fashion")

    result = @repository.list({ category: "sports" })

    assert_equal 0, result[:items].count
    assert_equal 0, result[:total_count]
  end

  test "sort=ratingでレードの高い順になる" do
    low_rating = Product.create!(name: "Low", description: "Desc", price: 1000, category: "electronics", rating: 2.0)
    high_rating = Product.create!(name: "High", description: "Desc", price: 2000, category: "electronics", rating: 4.5)
    mid_rating = Product.create!(name: "Mid", description: "Desc", price: 1500, category: "electronics", rating: 3.0)

    result = @repository.list({ sort: "rating" })

    ids = result[:items].map(&:id)
    assert_equal [ high_rating.id, mid_rating.id, low_rating.id ], ids
  end

  test "sort=price_ascで価格が安い順になる" do
    expensive = Product.create!(name: "Expensive", description: "Desc", price: 5000, category: "electronics")
    cheap = Product.create!(name: "Cheap", description: "Desc", price: 1000, category: "electronics")
    medium = Product.create!(name: "Medium", description: "Desc", price: 3000, category: "electronics")

    result = @repository.list({ sort: "price_asc" })

    ids = result[:items].map(&:id)
    assert_equal [ cheap.id, medium.id, expensive.id ], ids
  end

  test "sort=price_descで価格が高い順になる" do
    expensive = Product.create!(name: "Expensive", description: "Desc", price: 5000, category: "electronics")
    cheap = Product.create!(name: "Cheap", description: "Desc", price: 1000, category: "electronics")
    medium = Product.create!(name: "Medium", description: "Desc", price: 3000, category: "electronics")

    result = @repository.list({ sort: "price_desc" })

    ids = result[:items].map(&:id)
    assert_equal [ expensive.id, medium.id, cheap.id ], ids
  end

  test "sort=newestで作成日時が新しい順になる" do
    old = Product.create!(name: "Old", description: "Desc", price: 1000, category: "electronics", created_at: 2.days.ago)
    new = Product.create!(name: "New", description: "Desc", price: 2000, category: "electronics", created_at: Time.current)
    middle = Product.create!(name: "Middle", description: "Desc", price: 1500, category: "electronics", created_at: 1.day.ago)

    result = @repository.list({ sort: "newest" })

    ids = result[:items].map(&:id)
    assert_equal [ new.id, middle.id, old.id ], ids
  end

  test "sort指定なしはデフォルト順になる" do
    Product.create!(name: "Product1", description: "Desc", price: 1000, category: "electronics")
    Product.create!(name: "Product2", description: "Desc", price: 2000, category: "electronics")
    Product.create!(name: "Product3", description: "Desc", price: 1500, category: "electronics")

    result = @repository.list({})
    assert_equal 3, result[:items].count
  end

  test "ページネーションで意図した通りの件数になること" do
    10.times do |i|
      Product.create!(name: "Product #{i}", description: "Desc", price: 1000 + i * 100, category: "electronics")
    end

    result = @repository.list({ page: 1, per_page: 3 })

    assert_equal 3, result[:items].count
    assert_equal 10, result[:total_count]
  end

  test "ページ2を取得する" do
    10.times do |i|
      Product.create!(name: "Product #{i}", description: "Desc", price: 1000 + i * 100, category: "electronics")
    end

    result_page1 = @repository.list({ page: 1, per_page: 3 })
    result_page2 = @repository.list({ page: 2, per_page: 3 })

    ids_page1 = result_page1[:items].map(&:id)
    ids_page2 = result_page2[:items].map(&:id)

    assert_equal 3, result_page2[:items].count
    assert_not_equal ids_page1, ids_page2
  end

  test "per_pageが100を超える場合は100に制限される" do
    110.times do |i|
      Product.create!(name: "Product #{i}", description: "Desc", price: 1000, category: "electronics")
    end

    result = @repository.list({ page: 1, per_page: 200 })

    assert_equal 100, result[:items].count
    assert_equal 110, result[:total_count]
  end

  test "pageが0以下の場合は1ページ目が返される" do
    5.times do |i|
      Product.create!(name: "Product #{i}", description: "Desc", price: 1000, category: "electronics")
    end

    result = @repository.list({ page: 0, per_page: 2 })

    assert_equal 2, result[:items].count
  end

  test "categoryフィルタとsortとページネーションが組み合わさって機能する" do
    5.times do |i|
      Product.create!(name: "Electronics #{i}", description: "Desc", price: 1000 + i * 1000, category: "electronics", rating: (5 - i) * 1.0)
    end
    5.times do |i|
      Product.create!(name: "Fashion #{i}", description: "Desc", price: 100 + i * 100, category: "fashion")
    end

    result = @repository.list({ category: "electronics", sort: "price_asc", page: 1, per_page: 2 })

    assert_equal 2, result[:items].count
    assert_equal 5, result[:total_count]
    assert result[:items].all? { |p| p.category == "electronics" }
    prices = result[:items].map(&:price)
    assert_equal prices, prices.sort
  end

  test "findで単一レコードが取得できる" do
    product = Product.create!(name: "Product", description: "Desc", price: 1000, category: "electronics")

    found = @repository.find(product.id)

    assert_equal product.id, found.id
    assert_equal product.name, found.name
  end

  test "findで存在しないIDの場合はActiveRecord::RecordNotFoundが発生する" do
    assert_raises(ActiveRecord::RecordNotFound) do
      @repository.find("non-existent-id")
    end
  end

  test "createで新規レコードが作成される" do
    params = {
      name: "New Product",
      description: "New Description",
      price: 5000,
      category: "sports",
      stock: 100,
      rating: 4.0,
      review_count: 50
    }

    created = @repository.create(params)

    assert created.persisted?
    assert_equal "New Product", created.name
    assert_equal 5000, created.price
  end

  test "updateで既存レコードが更新される" do
    product = Product.create!(name: "Original", description: "Desc", price: 1000, category: "electronics")

    updated = @repository.update(product.id, { name: "Updated", price: 2000 })

    assert_equal "Updated", updated.name
    assert_equal 2000, updated.price
    assert_equal product.id, updated.id
  end

  test "destroyでレコードが削除される" do
    product = Product.create!(name: "Product", description: "Desc", price: 1000, category: "electronics")

    @repository.destroy(product.id)

    assert_raises(ActiveRecord::RecordNotFound) do
      Product.find(product.id)
    end
  end
end
