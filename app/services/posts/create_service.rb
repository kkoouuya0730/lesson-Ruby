module Posts
  class CreateService
    def initialize(params)
      @params = params
    end

    def call
      post = Post.new(@params)
      post.save!
      post
    end
  end
end