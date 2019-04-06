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
      (game.goals[:away] - game.goals[:home]).abs
    end
    (highest_difference_game.goals[:away] - highest_difference_game.goals[:home]).abs
  end

  def percentage_home_wins
    home_game_wins = @games.count do |game_id, game|
      game.home_win
    end
    (home_game_wins.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    (1 - percentage_home_wins).round(2)
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

  def count_of_goals_by_season
    hash = Hash.new(0)
    @games.each do |game_id, game|
      hash[game.season] += game.total_goals
    end
    hash
  end

  def average_goals_by_season
    hash = Hash.new(0)
    count_of_goals_by_season.each do |season, goal_count|
      value = goal_count.to_f / count_of_games_by_season[season]
      hash[season] = value.round(2)
    end
    hash
  end

end
