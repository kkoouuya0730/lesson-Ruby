require "test_helper"

class Posts::UpdateServiceTest < ActiveSupport::TestCase
  class FakeRepository
    attr_reader :received_id, :received_params

    def update(id, params)
      @received_id = id
      @received_params = params

      :updated_post
    end
  end

  test "repository#updateを呼び出す" do
    params = {
      title: "更新後タイトル"
    }

    repository = FakeRepository.new

    service = Posts::UpdateService.new(
      1,
      params,
      repository
    )

    result = service.call

    assert_equal 1, repository.received_id
    assert_equal params, repository.received_params
    assert_equal :updated_post, result
  end
end
