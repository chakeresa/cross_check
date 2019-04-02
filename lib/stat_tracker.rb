require 'csv'

class StatTracker
  def self.teams(filepath)
    team_data = CSV.table(filepath)
    team_data.inject({}) do |team_hash, team|
      team_hash[team[:team_id]] = team
      team_hash
    end
  end

  def self.games(filepath)
    game_data = CSV.table(filepath)
    game_data.inject({}) do |game_hash, game|
      game_hash[game[:game_id]] = game
      game_hash
    end
  end

  def self.game_teams(filepath)
    game_team_data = CSV.table(filepath)
    game_team_data.inject({}) do |game_team_hash, game_team_row|
      new_key = game_team_row[:game_id].to_s + "-" + game_team_row[:hoa].to_s
      game_team_hash[new_key] = game_team_row
      game_team_hash
    end
  end

  def self.from_csv(locations)

  end
end
