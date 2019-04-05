module LeagueStats
  def count_of_teams
    @teams.count
  end

  def best_offense
    best_offense_team = @teams.values.max_by do |team|
      total_team_goals = team.games.values.sum do |game|
        game[:goals]
      end
      total_team_games = team.games.values.count
      if total_team_games == 0
        -5 # TO DO: consider using medium data set for tests, then we can delete this
      else
        total_team_goals.to_f / total_team_games
      end
    end
    best_offense_team.team_name
  end

  def winningest_team
    winning_team = @teams.values.max_by do |team|
      (team.home_win_count + team.away_win_count).to_f / team.games.count
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
    # TO DO: consider combining these 2 enums by using inject
  end
end
