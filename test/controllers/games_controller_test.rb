require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should create game" do
  	assert_difference('Game.count') do
    	post :create, game: {name: 'Some title', description: 'Some description'}
  	end  
  end

end
