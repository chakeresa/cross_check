class Team
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link,
              :games

  def initialize(team_hash, games_hash)
    @team_id = team_hash[:team_id]
    @franchise_id = team_hash[:franchiseid]
    @short_name = team_hash[:shortname]
    @team_name = team_hash[:teamname]
    @abbreviation = team_hash[:abbreviation]
    @link = team_hash[:link]
    @games = generate_home_and_away_games(games_hash)
    @games_by_season = generate_games_by_season
  end

  def generate_home_and_away_games(games_hash)
    home_games = []
    away_games = []
    games_hash.values.each do |game_object|
      if game_object.team_ids[:home] == @team_id
        home_games << game_object
      else
        away_games << game_object
      end
    end
    {home: home_games, away: away_games}
  end

  def generate_games_by_season

  end

  def all_season_ids
    all_games_for_team = @games[:home] + @games[:away]
    all_seas_ids = all_games_for_team.map do |game|
      game.season
    end.uniq
  end

  def home_win_count
    @games[:home].count do |game|
      game.home_win
    end
  end

  def home_loss_count
    @games[:home].count do |game|
      !game.home_win
    end
  end

  def away_win_count
    @games[:away].count do |game|
      !game.home_win
    end
  end

  def away_loss_count
    @games[:away].count do |game|
      game.home_win
    end
  end

  def total_game_count
    @games.values.flatten.count
  end

  def most_goals_scored_in_a_game
    home_game_with_max_goals = @games[:home].max_by do |game_object|
      game_object.goals[:home]
    end
    away_game_with_max_goals = @games[:away].max_by do |game_object|
      game_object.goals[:away]
    end
    [home_game_with_max_goals.goals[:home], away_game_with_max_goals.goals[:away]].max
  end

  def fewest_goals_scored_in_a_game
    home_game_with_min_goals = @games[:home].min_by do |game_object|
      game_object.goals[:home]
    end
    away_game_with_min_goals = @games[:away].min_by do |game_object|
      game_object.goals[:away]
    end
    [home_game_with_min_goals.goals[:home], away_game_with_min_goals.goals[:away]].min
  end

end
