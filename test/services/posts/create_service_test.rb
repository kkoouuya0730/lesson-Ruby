require "test_helper"

class Posts::CreateServiceTest < ActiveSupport::TestCase
  class FakeRepository
    attr_reader :received_params

    def create(params)
      @received_params = params
      :created_post
    end
  end

  test "repository#createを呼び出す" do
    params = {
      title: "Rails入門",
      body: "本文"
    }

    repository = FakeRepository.new

    service = Posts::CreateService.new(
      params,
      repository
    )

    result = service.call

    assert_equal :created_post, result
    assert_equal params, repository.received_params
  end
end
