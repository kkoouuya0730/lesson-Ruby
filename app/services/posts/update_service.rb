module Posts
  class UpdateService
    def initialize(id, params)
      @id = id
      @params = params
    end

    def call
      post = Post.find(@id)
      post.update!(@params)
      post
    end
  end
end