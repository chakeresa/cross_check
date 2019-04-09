require_relative 'team'

class Season
  attr_reader :season_id

  def initialize(team_object, season_id)
    @team_id = team_object.team_id
    @season_id = season_id.to_s
    @regular_seas_games = generate_regular_seas_games(team_object)
    @post_seas_games = generate_post_seas_games(team_object)
    @all_games = generate_all_games
  end

  def generate_regular_seas_games(team_object)
    home_games = []
    away_games = []
    team_object.games[:home].each do |home_game|
      if home_game.type == "R" && home_game.season == @season_id
        home_games << home_game
      end
    end
    team_object.games[:away].each do |away_game|
      if away_game.type == "R" && away_game.season == @season_id
        away_games << away_game
      end
    end
    {home: home_games, away: away_games}
  end

  def generate_post_seas_games(team_object)
    home_games = []
    away_games = []
    team_object.games[:home].each do |home_game|
      if home_game.type == "P" && home_game.season == @season_id
        home_games << home_game
      end
    end
    team_object.games[:away].each do |away_game|
      if away_game.type == "P" && away_game.season == @season_id
        away_games << away_game
      end
    end
    {home: home_games, away: away_games}
  end

  def generate_all_games
    all_games_hash = {home: [], away: []}
    (@regular_seas_games[:home] + @post_seas_games[:home]).each do |home_game|
      all_games_hash[:home] << home_game
    end
    (@regular_seas_games[:away] + @post_seas_games[:away]).each do |away_game|
      all_games_hash[:away] << away_game
    end
    all_games_hash
  end

  # stuff for season summary:
  # :win_percentage, :total_goals_scored, :total_goals_against, :average_goals_scored, :average_goals_against

  def reg_seas_win_percentage
    home_wins = @regular_seas_games[:home].count do |home_game|
      home_game.home_win
    end
    away_wins = @regular_seas_games[:away].count do |away_game|
      !away_game.home_win
    end
    game_count_for_calc = [total_regular_game_count, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def post_seas_win_percentage
    home_wins = @post_seas_games[:home].count do |home_game|
      home_game.home_win
    end
    away_wins = @post_seas_games[:away].count do |away_game|
      !away_game.home_win
    end
    game_count_for_calc = [total_post_game_count, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def reg_seas_total_goals
    total_goals_scored = 0
    total_goals_against = 0
    @regular_seas_games[:home].each do |home_game|
      total_goals_scored += home_game.goals[:home]
      total_goals_against += home_game.goals[:away]
    end
    @regular_seas_games[:away].each do |away_game|
      total_goals_scored += away_game.goals[:away]
      total_goals_against += away_game.goals[:home]
    end
    hash = {scored: total_goals_scored, against: total_goals_against}
  end

  def post_seas_total_goals
    total_goals_scored = 0
    total_goals_against = 0
    @post_seas_games[:home].each do |home_game|
      total_goals_scored += home_game.goals[:home]
      total_goals_against += home_game.goals[:away]
    end
    @post_seas_games[:away].each do |away_game|
      total_goals_scored += away_game.goals[:away]
      total_goals_against += away_game.goals[:home]
    end
    hash = {scored: total_goals_scored, against: total_goals_against}
  end

  def total_regular_game_count
    home_game_count = @regular_seas_games[:home].count
    away_game_count = @regular_seas_games[:away].count
    home_game_count + away_game_count
  end

  def total_post_game_count
    home_game_count = @post_seas_games[:home].count
    away_game_count = @post_seas_games[:away].count
    home_game_count + away_game_count
  end

  def total_game_count
    total_regular_game_count + total_post_game_count
  end

# TO DO: don't divide by zero
  def reg_seas_avg_goals_per_game
    avg_goals_scored = (reg_seas_total_goals[:scored].to_f / total_regular_game_count).round(2)
    avg_goals_against = (reg_seas_total_goals[:against].to_f / total_regular_game_count).round(2)
    hash = {scored: avg_goals_scored, against: avg_goals_against}
  end

  def post_seas_avg_goals_per_game
    game_count_for_calc = [total_post_game_count, 1].max
    avg_goals_scored = (post_seas_total_goals[:scored].to_f / game_count_for_calc).round(2)
    avg_goals_against = (post_seas_total_goals[:against].to_f / game_count_for_calc).round(2)
    hash = {scored: avg_goals_scored, against: avg_goals_against}
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
    hash = {regular_season: regular_season_hash, postseason: post_season_hash}
  end
end
