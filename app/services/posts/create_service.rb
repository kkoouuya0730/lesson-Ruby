module Posts
  class CreateService
    def initialize(params, repository = Posts::PostRepository.new)
      @params = params
      @repository = repository
    end

    def call
      @repository.create(@params)
    end
  end
end
