module GameStats

  def highest_total_score
    highest_score_game = @games.values.max_by do |game|
      game[:away_goals] + game[:home_goals]
    end
    highest_score_game[:away_goals] + highest_score_game[:home_goals]
  end

  def lowest_total_score
    lowest_score_game = @games.values.min_by do |game|
      game[:away_goals] + game[:home_goals]
    end
    lowest_score_game[:away_goals] + lowest_score_game[:home_goals]
  end

  def biggest_blowout

  end

end
