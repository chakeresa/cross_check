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
    @games = games_hash # TO DO: refactor
  end

  def home_win_count
    @games.values.count do |game|
      game.team_ids[:home] == @team_id && game.home_win
    end
  end

  def home_loss_count
    @games.values.count do |game|
      game.team_ids[:home] == @team_id && !game.home_win
    end
  end

  def away_win_count
    @games.values.count do |game|
      game.team_ids[:away] == @team_id && !game.home_win
    end
  end

  def away_loss_count
    @games.values.count do |game|
      game.team_ids[:away] == @team_id && game.home_win
    end
  end

end
