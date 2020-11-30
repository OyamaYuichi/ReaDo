require 'test_helper'

class SummariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get summaries_index_url
    assert_response :success
  end

end
