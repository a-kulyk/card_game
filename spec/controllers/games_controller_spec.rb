require 'rails_helper'
require 'pry'

RSpec.describe GamesController, :type => :controller do

  before(:each) do
    login_user(create(:user))
  end


  describe " #index" do

    subject { JSON.parse(response.body).size }

    context 'when there is five games' do
      before do
        @games = create_list(:game, 5)
        get :index, format: :json
      end

      it {expect(response).to be_success}

      it 'returns five games' do
        expect eq(5)
      end

      it "renders JSON with a list of games" do
        expect(response.body).to eq(@games.to_json)
      end
    end

    context 'when there is no game' do
      it 'returns no game' do
        get :index, format: :json
        expect eq(0)
      end
    end
  end


  describe " #new" do
    it "initializes new game" do
      @game = build(:game, name: nil, description: nil)
      get :new

      expect(response.body).to eq(@game.to_json)
    end
  end


  describe " #show" do
    context 'when game exists' do
      it "renders JSON with a few game fields" do
        @game = create(:game)
        @player1 = create(:player, :game => @game, :user => controller.current_user)
        @expected_json = {
          :game_name  => @game.name,
          :game_description     => @game.description,
          :game_state    => @game.state,
          :current_user =>  controller.current_user.id
        }.to_json
        get :show, id: @game.id

        expect(response.body).to eq(@expected_json)
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'when  game ends' do
      it "returns status 'ended'" do
        @expected = { "status" => "ended" }.to_json
        get :show, id: 0

        expect(response.body).to eq(@expected)
      end
    end
  end

  describe "#create" do
    before do
      post :create, :game => {:name => "ProGame", :description => "ForProfyGamers"}
    end

    it "creates a new game" do
      expect(Game.last.name).to eq("ProGame")
      expect(Game.last.description).to eq("ForProfyGamers")
      expect(response.body).to eq(assigns(:game).to_json)
    end

    it "adds first player to the game" do
      expect(Player.last.game_id).to eq(Game.last.id)
    end
  end


  describe "#update" do
    before do
      post :create, :game => {:name => "ProGame", :description => "ForProfyGamers"}
      @game = Game.last
      @player2 = create(:player, :game => @game, :user => controller.current_user)
      post :update, id: @game.id , format: :json
    end

    it "adds second player to game" do
      expect(Player.last.game_id).to eq(@game.id)
      expect(Game.last.players[1]).not_to be_nil
    end

    it "creates deck and table" do
      expect(Game.last.table).not_to be_nil
      expect(Game.last.deck).not_to be_nil
	end

    it { expect(response.body).to eq(assigns(:game).to_json) }
  end



  # describe "#put_card" do
  #   it "should call put_card " do
  #     login_user(create(:user))
  #     card = stub(rang: 8, suite: "hearts")
  #     @game =  create(:game, :state => :move_of_first_player)
  #     @player = create(:player, :game => @game, :user => controller.current_user)

  #     @player.expects(:put_card).returns(card).once
  #     @game.expects(:get_card_from_player).once
  #     controller.stubs(:save_game).with(@game)

  #     # @game =  create(:game, :state => :move_of_first_player)
  #     # @player1 = create(:player, :game => @game, :user => controller.current_user)
  #     # @player2 = create(:player, :game => @game, :user => controller.current_user)
  #     # @table = create(:table, :game => @game)
  #     # @deck = create(:deck, :game => @game)
  #     # # controller.current_user.player.stubs(:put_card).returns(card)
  #     # GamesController.stubs(:save_game).with(@game)
  #     # @game.stubs(:get_card_from_player).with(card, @player1, @game.attacker)


  #     post :put_card, id: @game.id

  #   end
  # end


  describe "end_turn" do
    it "calls 'end_turn' method" do
      login_user(create(:user))
      @game =  create(:game, :state => :move_of_first_player)
      @game.stubs(:end_turn).with(controller.current_user.player)
      controller.stubs(:save_game).with(@game)
      # binding.pry
      post :end_turn, id: @game.id
      expect(response.body).to eq(@game.to_json)
    end
  end

  describe "#destroy" do
    it "destroys game" do
      @game = create(:game)
      delete :destroy, id: @game.id
      expect(Game.find_by_id(@game.id)).to be_nil
    end
  end
end


def login_user(user)
  sign_in user
end
