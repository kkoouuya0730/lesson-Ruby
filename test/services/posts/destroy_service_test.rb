require "test_helper"

class Posts::DestroyServiceTest < ActiveSupport::TestCase
  class FakeRepository
    attr_reader :received_id

    def destroy(id)
      @received_id = id
      :destroyed
    end
  end

  test "repository#destroyを呼び出す" do
    repository = FakeRepository.new

    service = Posts::DestroyService.new(
      1,
      repository
    )

    result = service.call

    assert_equal 1, repository.received_id
    assert_equal :destroyed, result
  end
end
