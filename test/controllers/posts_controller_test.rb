require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = Post.create!(
      title: "Rails入門",
      body: "Railsの学習記事"
    )
  end

  test "投稿一覧を取得できる" do
    get posts_url, as: :json

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 1, body["items"].count
    assert_equal 1, body["meta"]["total_count"]

    assert_equal @post.id, body["items"][0]["id"]
    assert_equal @post.title, body["items"][0]["title"]
  end

  test "キーワード検索できる" do
    Post.create!(title: "TypeScript入門")

    get posts_url,
        params: {
          keyword: "Rails"
        }

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 1, body["items"].count
    assert_equal "Rails入門", body["items"][0]["title"]
  end

  test "投稿を作成できる" do
    assert_difference("Post.count", 1) do
      post posts_url,
           params: {
             post: {
               title: "TypeScript入門",
               body: "TypeScriptの学習記事"
             }
           },
           as: :json
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal "TypeScript入門", body["title"]
    assert_equal "TypeScriptの学習記事", body["body"]
  end

  test "投稿詳細を取得できる" do
    get post_url(@post), as: :json

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal @post.id, body["id"]
    assert_equal @post.title, body["title"]
    assert_equal @post.body, body["body"]
  end

  test "投稿を更新できる" do
    patch post_url(@post),
          params: {
            post: {
              title: "更新後タイトル",
              body: "更新後本文"
            }
          },
          as: :json

    assert_response :success

    @post.reload

    assert_equal "更新後タイトル", @post.title
    assert_equal "更新後本文", @post.body

    body = JSON.parse(response.body)

    assert_equal "更新後タイトル", body["title"]
  end

  test "投稿を削除できる" do
    assert_difference("Post.count", -1) do
      delete post_url(@post), as: :json
    end

    assert_response :no_content
  end
end
