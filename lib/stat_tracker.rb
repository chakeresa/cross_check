require 'csv'

class StatTracker
  def teams(filepath)
    team_data = CSV.table(filepath)
    team_data.inject({}) do |team_hash, team|
      team_hash[team[:team_id]] = team
      team_hash
    end
  end

  def games(filepath)
    game_data = CSV.table(filepath)
    game_data.inject({}) do |game_hash, game|
      game_hash[game[:game_id]] = game
      game_hash
    end
  end
end
