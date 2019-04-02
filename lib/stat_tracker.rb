require 'csv'

class StatTracker
  def teams(filepath)
    team_data = CSV.table(filepath)
    hash = {}
    team_data.each do |team|
      hash[team[:team_id]] = team
    end
    hash
  end
end
