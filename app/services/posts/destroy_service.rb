module Posts
  class DestroyService
    def initialize(id, repository = Posts::PostRepository.new)
      @id = id
      @repository = repository
    end

    # 一旦物理削除
    def call
      post = @repository.find(@id)
      @repository.destroy(post)
    end
  end
end