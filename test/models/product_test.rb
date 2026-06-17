require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "必須項目があれば有効" do
    product = Product.new(
      name: "Sample Product",
      description: "sample",
      price: 1200,
      category: "goods"
    )

    assert product.valid?
  end

  test "nameがなければ無効" do
    product = Product.new(
      name: nil,
      description: "sample",
      price: 1200,
      category: "goods"
    )

    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end
end
