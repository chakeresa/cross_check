module LeagueStats
  def count_of_teams
    @teams.count
  end

  def best_offense
    best_offense_team = @teams.values.max_by do |team|
      total_team_goals = team.games[:home].sum do |game|
        game.goals[:home]
      end
      total_team_goals += team.games[:away].sum do |game|
        game.goals[:away]
      end
      total_team_goals.to_f / team.total_game_count
    end
    best_offense_team.team_name
  end

  def worst_offense
    worst_offense_team = @teams.values.min_by do |team|
      total_team_goals = team.games[:home].sum do |game|
        game.goals[:home]
      end
      total_team_goals += team.games[:away].sum do |game|
        game.goals[:away]
      end
      total_team_goals.to_f / team.total_game_count
    end
    worst_offense_team.team_name
  end

  def best_defense
    best_defense_team = @teams.values.min_by do |team|
      total_opponent_goals = team.games[:away].sum do |game|
        game.goals[:home]
      end
      total_opponent_goals += team.games[:home].sum do |game|
        game.goals[:away]
      end
      total_opponent_goals.to_f / team.total_game_count
    end
    best_defense_team.team_name
  end

  def worst_defense
    worst_defense_team = @teams.values.max_by do |team|
      total_opponent_goals = team.games[:away].sum do |game|
        game.goals[:home]
      end
      total_opponent_goals += team.games[:home].sum do |game|
        game.goals[:away]
      end
      total_opponent_goals.to_f / team.total_game_count
    end
    worst_defense_team.team_name
  end

  def highest_scoring_visitor
    total_games = Hash.new(0)
    total_away_goals_by_team_ids = Hash.new(0)
    @games.values.each do |game|
      total_away_goals_by_team_ids[game.team_ids[:away]] += game.goals[:away]
      total_games[game.team_ids[:away]] += 1
    end
    averages = Hash.new(0)
    total_away_goals_by_team_ids.map do |team_id, away_goals|
      averages[team_id] = away_goals.to_f / total_games[team_id]
    end
    highest_average = averages.max_by {|team_id, average_goals| average_goals}
    @teams[highest_average[0]].team_name
  end

  def highest_scoring_home_team
    total_games = Hash.new(0)
    total_home_goals_by_team_ids = Hash.new(0)
    @games.values.each do |game|
      total_home_goals_by_team_ids[game.team_ids[:home]] += game.goals[:home]
      total_games[game.team_ids[:home]] += 1
    end
    averages = Hash.new(0)
    total_home_goals_by_team_ids.map do |team_id, home_goals|
      averages[team_id] = home_goals.to_f / total_games[team_id]
    end
    highest_average = averages.max_by {|team_id, average_goals| average_goals}
    @teams[highest_average[0]].team_name
  end

  def lowest_scoring_visitor
    total_games = Hash.new(0)
    total_away_goals_by_team_ids = Hash.new(0)
    @games.values.each do |game|
      total_away_goals_by_team_ids[game.team_ids[:away]] += game.goals[:away]
      total_games[game.team_ids[:away]] += 1
    end
    averages = Hash.new(0)
    total_away_goals_by_team_ids.map do |team_id, away_goals|
      averages[team_id] = away_goals.to_f / total_games[team_id]
    end
    lowest_average = averages.min_by {|team_id, average_goals| average_goals}
    @teams[lowest_average[0]].team_name
  end

  def lowest_scoring_home_team
    total_games = Hash.new(0)
    total_home_goals_by_team_ids = Hash.new(0)
    @games.values.each do |game|
      total_home_goals_by_team_ids[game.team_ids[:home]] += game.goals[:home]
      total_games[game.team_ids[:home]] += 1
    end
    averages = Hash.new(0)
    total_home_goals_by_team_ids.map do |team_id, home_goals|
      averages[team_id] = home_goals.to_f / total_games[team_id]
    end
    lowest_average = averages.min_by {|team_id, average_goals| average_goals}
    @teams[lowest_average[0]].team_name
  end

  def winningest_team
    winning_team = @teams.values.max_by do |team|
      (team.home_win_count + team.away_win_count).to_f / team.total_game_count
    end
    winning_team.team_name
  end

  def best_fans
    best_fans_team = @teams.values.max_by do |team|
      total_home_count = team.home_win_count + team.home_loss_count
      total_away_count = team.away_win_count + team.away_loss_count
      team.home_win_count.to_f / total_home_count - team.away_win_count.to_f / total_away_count
    end
    best_fans_team.team_name
  end

  def worst_fans
    worst_fans_teams = @teams.values.find_all do |team|
      total_home_count = team.home_win_count + team.home_loss_count
      total_away_count = team.away_win_count + team.away_loss_count
      diff = team.home_win_count.to_f / total_home_count - team.away_win_count.to_f / total_away_count
      diff < 0
    end
    worst_fans_teams.map do |team|
      team.team_name
    end
  end
end
