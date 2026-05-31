require "test_helper"

class Posts::IndexServiceTest < ActiveSupport::TestCase
  class FakeRepository
    attr_reader :received_params

    def list(params)
      @received_params = params

      {
        items: [],
        total_count: 0
      }
    end
  end

  test "repository#listを呼び出す" do
    params = {
      keyword: "Rails",
      page: 1
    }

    repository = FakeRepository.new

    service = Posts::IndexService.new(
      params,
      repository
    )

    result = service.call

    assert_equal params, repository.received_params

    assert_equal(
      {
        items: [],
        total_count: 0
      },
      result
    )
  end
end
