module Posts
  class IndexService
    def initialize(params, repository = Posts::PostRepository.new)
      @params = params
      @repository = repository
    end

    def call
      @repository.list(@params)
    end
  end
end
