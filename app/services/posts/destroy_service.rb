module Posts
  class DestroyService
    def initialize(id)
      @id = id
    end

    # 一旦物理削除
    def call
      post = Post.find(@id)
      post.destroy!
      post
    end
  end
end