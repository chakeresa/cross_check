module TeamStats
  def team_info(team_id)
    team_object = @teams[team_id.to_i]
    {"team_id" => team_object.team_id.to_s,
     "franchise_id" => team_object.franchise_id.to_s,
     "short_name" => team_object.short_name,
     "team_name" => team_object.team_name,
     "abbreviation" => team_object.abbreviation,
     "link" => team_object.link}
  end

  def win_percentage_for_season(team, season)
    home_matches = 0; away_matches = 0; home_wins = 0; away_wins = 0
    team.games[:home].each do |home_game|
      if home_game.season == season
        home_matches += 1
        home_wins += 1 if home_game.home_win
      end
    end
    team.games[:away].each do |away_game|
      if away_game.season == season
        away_matches += 1
        away_wins += 1 if !away_game.home_win
      end
    end
    ((home_wins.to_f + away_wins) / (home_matches + away_matches)).round(2)
  end

  def all_season_ids(team_id)
    @teams[team_id.to_i].all_season_ids
  end

  def best_season(team_id)
    team_object = @teams[team_id.to_i]
    all_season_ids(team_id).max_by do |seas_id|
      win_percentage_for_season(team_object, seas_id)
    end
  end

  def worst_season(team_id)
    team_object = @teams[team_id.to_i]
    all_season_ids(team_id).min_by do |seas_id|
      win_percentage_for_season(team_object, seas_id)
    end
  end

  def average_win_percentage(team_id)
    team_object = @teams[team_id.to_i]
    home_wins = team_object.games[:home].count do |home_game|
      home_game.home_win
    end
    away_wins = team_object.games[:away].count do |away_game|
      !away_game.home_win
    end
    ((home_wins.to_f + away_wins) / team_object.total_game_count).round(2)
  end

  def goals_for_team_in_game(team_object, game_object)
    if game_object.team_ids[:home] == team_object.team_id
      game_object.goals[:home]
    else
      game_object.goals[:away]
    end
  end

  def most_goals_scored(team_id)
    team_object = @teams[team_id.to_i]
    team_object.most_goals_scored_in_a_game
  end

  def fewest_goals_scored(team_id)
    team_object = @teams[team_id.to_i]
    team_object.fewest_goals_scored_in_a_game
  end

  def all_opponent_team_ids(team_id)
    team_object = @teams[team_id.to_i]
    all_opp_team_ids_when_home = team_object.games[:home].map do |home_game|
      home_game.team_ids[:away]
    end
    all_opp_team_ids_when_away = team_object.games[:away].map do |home_game|
      home_game.team_ids[:home]
    end
    (all_opp_team_ids_when_home + all_opp_team_ids_when_away).uniq
  end

  def win_percentage_for_opponent(team, opp_id)
    home_matches = 0; away_matches = 0; home_wins = 0; away_wins = 0
    team.games[:home].each do |home_game|
      if home_game.team_ids[:away] == opp_id
        home_matches += 1
        home_wins += 1 if home_game.home_win
      end
    end
    team.games[:away].each do |away_game|
      if away_game.team_ids[:home] == opp_id
        away_matches += 1
        away_wins += 1 if !away_game.home_win
      end
    end
    ((home_wins.to_f + away_wins) / (home_matches + away_matches)).round(2)
  end

  def favorite_opponent(team_id)
    head_to_head(team_id).max_by { |team_name, win_pct| win_pct }.first
  end

  def rival(team_id)
    head_to_head(team_id).min_by { |team_name, win_pct| win_pct }.first
  end

  def team_and_opp_goal_difference(team_id)
    team_object = @teams[team_id.to_i]
    home_goal_difference = team_object.games[:home].map do |home_game|
      home_game.goals[:home] - home_game.goals[:away]
    end
    away_goal_difference = team_object.games[:away].map do |away_game|
      away_game.goals[:away] - away_game.goals[:home]
    end
    home_goal_difference + away_goal_difference
  end

  def biggest_team_blowout(team_id)
    team_and_opp_goal_difference(team_id).max
  end

  def worst_loss(team_id)
    team_and_opp_goal_difference(team_id).min.abs
  end

  def head_to_head(team_id)
    team_object = @teams[team_id.to_i]
    hash = Hash.new(0)
    all_opponent_team_ids(team_id).each do |opp_team_id|
      opponent_team_object = @teams[opp_team_id.to_i]
      hash[opponent_team_object.team_name] = win_percentage_for_opponent(team_object, opp_team_id)
    end
    hash
  end

  def seasonal_summary(team_id)
    team_object = @teams[team_id.to_i]
    team_object.seasons_hash.values.inject({}) do |accum, season_object|
      accum[season_object.season_id] = season_object.summary
      accum
    end
  end
end
