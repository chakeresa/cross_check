require 'csv'

class StatTracker
  def teams(filepath)
    team_data = CSV.table(filepath)
    team_data.inject({}) do |team_hash, team|
      team_hash[team[:team_id]] = team
      team_hash
    end
  end
end
