require_relative 'team'
require_relative 'seasonal_summary'

class Season
  include SeasonalSummary

  attr_reader :season_id,
              :team_name,
              :all_games,
              :team_id

  def initialize(team_object, season_id)
    @team_id = team_object.team_id
    @team_name = team_object.team_name
    @season_id = season_id.to_s
    @regular_seas_games = generate_regular_seas_games(team_object)
    @post_seas_games = generate_post_seas_games(team_object)
    @all_games = generate_all_games
  end

  def generate_regular_seas_games(team_object)
    home_games = []; away_games = []
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
    home_games = []; away_games = []
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

  def total_regular_game_count
    @regular_seas_games[:home].count + @regular_seas_games[:away].count
  end

  def total_post_game_count
    @post_seas_games[:home].count + @post_seas_games[:away].count
  end

  def total_game_count
    total_regular_game_count + total_post_game_count
  end

  def goals_per_shots_ratio
    home_goals = @all_games[:home].sum {|home_game| home_game.goals_wo_shootout[:home]}
    away_goals = @all_games[:away].sum {|away_game| away_game.goals_wo_shootout[:away]}
    home_shots = @all_games[:home].sum {|home_game| home_game.shots[:home]}
    away_shots = @all_games[:away].sum {|away_game| away_game.shots[:away]}
    ((home_goals + away_goals).to_f / (home_shots + away_shots)).round(3)
  end

  def total_hits
    total_hits_count = @all_games[:home].sum do |home_game|
      home_game.hits[:home]
    end
    total_hits_count += @all_games[:away].sum do |away_game|
      away_game.hits[:away]
    end
  end

  def total_power_play_goals
    total_pp_goals_count = @all_games[:home].sum do |home_game|
      home_game.power_play_goals[:home]
    end
    total_pp_goals_count += @all_games[:away].sum do |away_game|
      away_game.power_play_goals[:away]
    end
  end

  def total_goals_wo_shootout
    total_goals_wo_so_count = @all_games[:home].sum do |home_game|
      home_game.goals_wo_shootout[:home]
    end
    total_goals_wo_so_count += @all_games[:away].sum do |away_game|
      away_game.goals_wo_shootout[:away]
    end
  end

end
