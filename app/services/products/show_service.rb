module Products
  class ShowService
    def initialize(id, repository = Products::ProductRepository.new)
      @id = id
      @repository = repository
    end

    def call
      @repository.find(@id)
    end
  end
end
