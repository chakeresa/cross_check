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

end
