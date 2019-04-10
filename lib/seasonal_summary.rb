module SeasonalSummary
  def reg_seas_win_percentage
    home_wins = @regular_seas_games[:home].count do |home_game|
      home_game.home_win?
    end
    away_wins = @regular_seas_games[:away].count do |away_game|
      !away_game.home_win?
    end
    game_count_for_calc = [total_regular_game_count, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def post_seas_win_percentage
    home_wins = @post_seas_games[:home].count do |home_game|
      home_game.home_win?
    end
    away_wins = @post_seas_games[:away].count do |away_game|
      !away_game.home_win?
    end
    game_count_for_calc = [total_post_game_count, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def reg_seas_total_goals
    reg_home_goals_scored = @regular_seas_games[:home].sum {|home_game| home_game.goals[:home]}
    reg_home_goals_against = @regular_seas_games[:home].sum {|home_game| home_game.goals[:away]}
    reg_away_goals_scored = @regular_seas_games[:away].sum {|away_game| away_game.goals[:away]}
    reg_away_goals_against = @regular_seas_games[:away].sum {|away_game| away_game.goals[:home]}
    {scored: reg_home_goals_scored + reg_away_goals_scored, against: reg_home_goals_against + reg_away_goals_against}
  end

  def post_seas_total_goals
    post_home_goals_scored = @post_seas_games[:home].sum {|home_game| home_game.goals[:home]}
    post_home_goals_against = @post_seas_games[:home].sum {|home_game| home_game.goals[:away]}
    post_away_goals_scored = @post_seas_games[:away].sum {|away_game| away_game.goals[:away]}
    post_away_goals_against = @post_seas_games[:away].sum {|away_game| away_game.goals[:home]}
    {scored: post_home_goals_scored + post_away_goals_scored, against: post_home_goals_against + post_away_goals_against}
  end

  def reg_seas_avg_goals_per_game
    avg_goals_scored = (reg_seas_total_goals[:scored].to_f / total_regular_game_count).round(2)
    avg_goals_against = (reg_seas_total_goals[:against].to_f / total_regular_game_count).round(2)
    {scored: avg_goals_scored, against: avg_goals_against}
  end

  def post_seas_avg_goals_per_game
    game_count_for_calc = [total_post_game_count, 1].max
    avg_goals_scored = (post_seas_total_goals[:scored].to_f / game_count_for_calc).round(2)
    avg_goals_against = (post_seas_total_goals[:against].to_f / game_count_for_calc).round(2)
    {scored: avg_goals_scored, against: avg_goals_against}
  end

  def summary
    regular_season_hash = {
      win_percentage: reg_seas_win_percentage,
      total_goals_scored: reg_seas_total_goals[:scored],
      total_goals_against: reg_seas_total_goals[:against],
      average_goals_scored: reg_seas_avg_goals_per_game[:scored],
      average_goals_against: reg_seas_avg_goals_per_game[:against]
    }
    post_season_hash = {
      win_percentage: post_seas_win_percentage,
      total_goals_scored: post_seas_total_goals[:scored],
      total_goals_against: post_seas_total_goals[:against],
      average_goals_scored: post_seas_avg_goals_per_game[:scored],
      average_goals_against: post_seas_avg_goals_per_game[:against]
    }
    {regular_season: regular_season_hash, postseason: post_season_hash}
  end
end
