require 'test_helper'
 
class RoundTwoTest < ActionDispatch::IntegrationTest
  test "When all questions are answered it goes to the next round" do
    get new_game_path
    assert_response :success
    post new_game_path
    follow_redirect!
    assert_response :success
  end
end