require "test_helper"

class Posts::PostRepositoryTest < ActiveSupport::TestCase
  def setup
    @repository = Posts::PostRepository.new
  end

  test "パラメータがない場合、全ての件数が返る" do
    Post.create!(title: "post1")
    Post.create!(title: "post2")

    result = @repository.list({})

    assert_equal 2, result[:items].count
  end

  test "キーワードに一致するレコードが返る" do
    rails_post = Post.create!(title: "Rails入門")
    Post.create!(title: "TypeScript入門")

    result = @repository.list({ keyword: "Rails" })

    assert_equal 1, result[:items].count
    assert_equal 1, result[:total_count]
    assert_equal rails_post.id, result[:items].first.id
  end

  test "キーワードが空の時に全件返る" do
    Post.create!(title: "Rails入門1")
    Post.create!(title: "Rails入門2")

    result = @repository.list({ keyword: "" })

    assert_equal 2, result[:items].count
    assert_equal 2, result[:total_count]
  end

  test "キーワードが一致しなかったときに0件になる" do
    Post.create!(title: "Rails入門1")
    Post.create!(title: "Rails入門2")

    result = @repository.list({ keyword: "TypeScript入門" })

    assert_equal 0, result[:items].count
    assert_equal 0, result[:total_count]
  end

  test "キーワードがnilの時に全件返る" do
    Post.create!(title: "Rails入門1")
    Post.create!(title: "Rails入門2")

    result = @repository.list({ keyword: nil })

    assert_equal 2, result[:items].count
    assert_equal 2, result[:total_count]
  end

  test "キーワードの部分一致でレコードが返る" do
    rails_post = Post.create!(title: "Rails入門")
    Post.create!(title: "TypeScript入門")

    result = @repository.list({ keyword: "ils" })

    assert_equal 1, result[:items].count
    assert_equal 1, result[:total_count]
    assert_equal rails_post.id, result[:items].first.id
  end

  test "ページネーション時に意図した通りの件数になること" do
    20.times do |i|
      Post.create!(title: "Post #{i}")
    end

    result = @repository.list(
      page: 1,
      per_page: 5
    )

    assert_equal 5, result[:items].count
  end

  test "ページネーションしてもtotal_countは全件数を返す" do
    20.times do |i|
      Post.create!(title: "Post #{i}")
    end

    result = @repository.list(
      page: 1,
      per_page: 5
    )

    assert_equal 5, result[:items].count
    assert_equal 20, result[:total_count]
  end

  test "title_ascでタイトル昇順になる" do
    Post.create!(title: "C")
    Post.create!(title: "A")
    Post.create!(title: "B")

    result = @repository.list(sort: "title_asc")

    assert_equal(
      [ "A", "B", "C" ],
      result[:items].pluck(:title)
    )
  end

  test "title_descでタイトル降順になる" do
    Post.create!(title: "C")
    Post.create!(title: "A")
    Post.create!(title: "B")

    result = @repository.list(sort: "title_desc")

    assert_equal(
      [ "C", "B", "A" ],
      result[:items].pluck(:title)
    )
  end

  test "created_at_ascで古い順になる" do
    old_post, new_post = create_posts_for_sort()

    result = @repository.list(sort: "created_at_asc")

    assert_equal(
      [ old_post.id, new_post.id ],
      result[:items].pluck(:id)
    )
  end

  test "created_at_descで新しい順になる" do
    old_post, new_post = create_posts_for_sort()

    result = @repository.list(sort: "created_at_desc")

    assert_equal(
      [ new_post.id, old_post.id ],
      result[:items].pluck(:id)
    )
  end

  test "sortがnilの場合はcreated_at_descになる" do
    old_post, new_post = create_posts_for_sort()

    result = @repository.list(sort: nil)

    assert_equal(
      [ new_post.id, old_post.id ],
      result[:items].pluck(:id)
    )
  end

  test "不正なsortの場合はcreated_at_descになる" do
    old_post, new_post = create_posts_for_sort()

    result = @repository.list(sort: "invalid")

    assert_equal(
      [ new_post.id, old_post.id ],
      result[:items].pluck(:id)
    )
  end

  private
  def create_posts_for_sort
    old_post = Post.create!(
      title: "old",
      created_at: 2.days.ago
    )

    new_post = Post.create!(
      title: "new",
      created_at: Time.current
    )
    [ old_post, new_post ]
  end
end
