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
        if game.team_ids[:away] == team.team_id
          game.goals[:home]
        elsif game.team_ids[:home] == team.team_id
          game.goals[:away]
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
        if game.team_ids[:away] == team.team_id
          game.goals[:home]
        elsif game.team_ids[:home] == team.team_id
          game.goals[:away]
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

  def highest_scoring_visitor
    # Match all the goals with corresponding team_id
      # Team id points to array of away goals
      total_games = Hash.new(0)
      scores = Hash.new(0)
      @games.values.each do |game|
        scores[game.team_ids[:away]] += game.goals[:away]
        total_games[game.team_ids[:away]] += 1
      end
    # sum away goals per each team / total number of away games per team

    # For every score, divide by total games played hash
    averages = Hash.new(0)
    scores.map do |team_id, score|
      averages[team_id] = score.to_f / total_games[team_id]
    end
    # Find team id with highest average
    highest_average = averages.max_by {|team_id, average_goals| average_goals}

    # Match name of team with team id
    @teams[highest_average[0]].team_name
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
