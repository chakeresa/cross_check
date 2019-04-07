module TeamStats
  def team_info(team_id)
    team_object = @teams[team_id.to_i]
    hash = {
      "team_id" => team_object.team_id.to_s,
      "franchise_id" => team_object.franchise_id.to_s,
      "short_name" => team_object.short_name,
      "team_name" => team_object.team_name,
      "abbreviation" => team_object.abbreviation,
      "link" => team_object.link
    }
  end

  # def head_to_head(team_id)
  #
  # end

end
