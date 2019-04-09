require_relative 'team'

class Season
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
    reg_seas_game_ct = @regular_seas_games[:home].count + @regular_seas_games[:away].count
    game_count_for_calc = [reg_seas_game_ct, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def post_seas_win_percentage
    home_wins = @post_seas_games[:home].count do |home_game|
      home_game.home_win
    end
    away_wins = @post_seas_games[:away].count do |away_game|
      !away_game.home_win
    end
    post_seas_game_ct = @post_seas_games[:home].count + @post_seas_games[:away].count
    game_count_for_calc = [post_seas_game_ct, 1].max
    ((home_wins.to_f + away_wins) / game_count_for_calc).round(2)
  end

  def post_seas_total_goals_scored
    total_goals = @post_seas_games[:home].sum do |home_game|
      home_game.goals[:home]
    end
    total_goals += @post_seas_games[:away].sum do |away_game|
      away_game.goals[:away]
    end
    total_goals
  end

  def total_game_count
    home_game_count = @all_games[:home].count
    away_game_count = @all_games[:away].count
    home_game_count + away_game_count
  end
end