module LeagueStats
  def count_of_teams
    all_team_names = @teams.values.map do |team|
      team.team_name
    end
    all_team_names.uniq.count
  end

  def best_offense
    best_offense_team = @teams.values.max_by do |team|
      total_team_goals = team.games.values.sum do |game|
        game[:goals]
      end
      total_team_games = team.games.values.count
      if total_team_games == 0
        -5
      else
        total_team_goals.to_f / total_team_games
      end
    end
    best_offense_team.team_name
  end

  def worst_offense
    worst_offense_team = @teams.values.min_by do |team|
      total_team_goals = team.games.values.sum do |game|
        game[:goals]
      end
      total_team_games = team.games.values.count
      if total_team_games == 0
        500
      else
        total_team_goals.to_f / total_team_games
      end
    end
    worst_offense_team.team_name
  end

  def best_defense
    best_defense_team = @teams.values.min_by do |team|
      total_opponent_goals = @games.values.sum do |game|
        if game.away_team_id == team.team_id
          game.home_goals
        elsif game.home_team_id == team.team_id
          game.away_goals
        else
          0
        end
      end
      total_team_games = team.games.values.count
      if total_team_games == 0
        500
      else
        total_opponent_goals.to_f / total_team_games
      end
    end
    best_defense_team.team_name
  end

  def worst_defense
    worst_defense_team = @teams.values.max_by do |team|
      total_opponent_goals = @games.values.sum do |game|
        if game.away_team_id == team.team_id
          game.home_goals
        elsif game.home_team_id == team.team_id
          game.away_goals
        else
          0
        end
      end
      total_team_games = team.games.values.count
      if total_team_games == 0
        -5
      else
        total_opponent_goals.to_f / total_team_games
      end
    end
    worst_defense_team.team_name
  end

end
