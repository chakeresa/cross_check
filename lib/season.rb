require_relative 'team'

class Season
  def initialize(team_object, season_id)
    @team_object = team_object
    @team_id = team_object.team_id
    @season_id = season_id.to_s
    @regular_seas_games = generate_regular_seas_games
    @post_seas_games = generate_post_seas_games
  end

  def generate_regular_seas_games
    home_games = []
    away_games = []
    @team_object.games[:home].each do |home_game|
      if home_game.type == "R" && home_game.season == @season_id
        home_games << home_game
      end
    end
    @team_object.games[:away].each do |away_game|
      if away_game.type == "R" && away_game.season == @season_id
        away_games << away_game
      end
    end
    {home: home_games, away: away_games}
  end

  def generate_post_seas_games
    home_games = []
    away_games = []
    @team_object.games[:home].each do |home_game|
      if home_game.type == "P" && home_game.season == @season_id
        home_games << home_game
      end
    end
    @team_object.games[:away].each do |away_game|
      if away_game.type == "P" && away_game.season == @season_id
        away_games << away_game
      end
    end
    {home: home_games, away: away_games}
  end
end
