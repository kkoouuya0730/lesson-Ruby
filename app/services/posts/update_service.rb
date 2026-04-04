module Posts
  class UpdateService
    def initialize(id, params, repository = Posts::PostRepository.new)
      @id = id
      @params = params
      @repository = repository
    end

    def call
      @repository.update(@id, @params)
    end
  end
end