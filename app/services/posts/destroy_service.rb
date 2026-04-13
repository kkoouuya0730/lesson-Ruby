module Posts
  class DestroyService
    def initialize(id, repository = Posts::PostRepository.new)
      @id = id
      @repository = repository
    end

    # 一旦物理削除
    def call
      @repository.destroy(@id)
    end
  end
end
