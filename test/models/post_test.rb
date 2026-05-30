require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "titleがあれば有効" do
    post = Post.new(
      title: "サンプル",
      body: "sample"
    )
    assert post.valid?
  end

  test "titleがなければ有効" do
    post = Post.new(
      title: nil,
      body: "sample"
    )
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end
end
