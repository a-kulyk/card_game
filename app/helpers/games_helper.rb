module GamesHelper

  def set_statistic
    if @game.players[1]
      @user1 = User.find @game.players[0].user_id
      @user2 = User.find @game.players[1].user_id

      @user1.games_count += 1
      @user2.games_count += 1

      if @game.winner

        if @user1 == @game.winner
          @user1.win_count += 1
          @user2.lose_count += 1
        else
          @user2.win_count += 1
          @user1.lose_count += 1
        end
      else
        if current_user == @user1
          @user2.win_count += 1
          @user1.lose_count += 1
        else
          @user1.win_count += 1
          @user2.lose_count += 1
        end
      end
    end
  end

  def check_game_end
    if @game.game_ended?
      if @game.players[0].cards_count == 0
        @game.winner, @game.loser = @game.players[1], @game.players[0]
      else
        @game.winner, @game.loser = @game.players[0], @game.players[1]
      end
      @game.save
      end_game
      return true
    else
      return false
    end
  end
end