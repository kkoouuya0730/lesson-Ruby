module Products
  class IndexService
    def initialize(params = {}, repository = Products::ProductRepository.new)
      @params = params
      @repository = repository
    end

    def call
      @repository.list(@params)
    end
  end
end
