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

  def biggest_blowout
    highest_difference_game = @games.values.max_by do |game|
      (game.away_goals - game.home_goals).abs
    end
    (highest_difference_game.away_goals - highest_difference_game.home_goals).abs
  end

  def percentage_home_wins
    home_game_wins = @games.count do |game_id, game|
      game.outcome.start_with?("home win")
    end
    (home_game_wins.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    1 - percentage_home_wins
  end

  def count_of_games_by_season
    hash = Hash.new(0)
    @games.each do |game_id, game|
      hash[game.season] += 1
    end
    hash
  end

  def average_goals_per_game
    total_goals = @games.sum do |game_id, game|
      game.total_goals
    end
    (total_goals.to_f / @games.count).round(2)
  end
end
