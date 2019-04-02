module GameStats

  def highest_total_score

    highest_score_game = @games.values.max_by do |game|
      # require 'pry'; binding.pry
      game[:away_goals] + game[:home_goals]
    end
    highest_score_game[:away_goals] + highest_score_game[:home_goals]
  end

end
