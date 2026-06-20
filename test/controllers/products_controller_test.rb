require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = Product.create!(
      name: "Test Product",
      description: "Test Description",
      price: 9999,
      category: "electronics",
      stock: 50,
      rating: 4.5,
      review_count: 10
    )
  end

  test "should get index" do
    get products_url
    assert_response :success
    json = response.parsed_body
    assert_includes json.keys, "items"
    assert_includes json.keys, "meta"
    assert json["items"].length > 0
  end

  test "should get show" do
    get product_url(@product)
    assert_response :success
    json = response.parsed_body
    assert_equal @product.id, json["id"]
    assert_equal @product.name, json["name"]
  end
end
