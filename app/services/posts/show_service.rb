module Posts
  class ShowService
    def initialize(id, repository = Posts::PostRepository.new)
      @id = id
      @repository = repository
    end

    def call
      @repository.find(@id)
    end
  end
end
