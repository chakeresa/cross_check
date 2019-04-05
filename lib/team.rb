class Team
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link,
              :games

  def initialize(team_info, game_info)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseid]
    @short_name = team_info[:shortname]
    @team_name = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
    @games = game_info
  end

  def home_win_count
    @games.values.count do |game|
      game[:hoa] == "home" && game[:won] == "TRUE"
    end
  end

  def home_loss_count
    @games.values.count do |game|
      game[:hoa] == "home" && game[:won] == "FALSE"
    end
  end

  def away_win_count
    @games.values.count do |game|
      game[:hoa] == "away" && game[:won] == "TRUE"
    end
  end

  def away_loss_count
    @games.values.count do |game|
      game[:hoa] == "away" && game[:won] == "FALSE"
    end
  end

end
