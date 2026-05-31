require "test_helper"

class Posts::ShowServiceTest < ActiveSupport::TestCase
  class FakeRepository
    attr_reader :received_id

    def find(id)
      @received_id = id
      :found_post
    end
  end

  test "repository#findを呼び出す" do
    repository = FakeRepository.new

    service = Posts::ShowService.new(
      1,
      repository
    )

    result = service.call

    assert_equal 1, repository.received_id
    assert_equal :found_post, result
  end
end
