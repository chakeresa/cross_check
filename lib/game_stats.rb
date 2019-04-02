module GameStats

  def highest_total_score
    highest_score_game = @games.values.max_by do |game|
      game.total_goals
    end
    highest_score_game.total_goals
  end

  def lowest_total_score
    lowest_score_game = @games.values.min_by do |game|
      game.total_goals
    end
    lowest_score_game.total_goals
  end

  # def biggest_blowout
  #
  # end

end
