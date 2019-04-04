module LeagueStats
  def count_of_teams
    all_team_names = @teams.values.map do |team|
      team.team_name
    end
    all_team_names.uniq.count
  end

  # def best_offense
  #
  # end

end
