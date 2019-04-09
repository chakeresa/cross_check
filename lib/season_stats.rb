module SeasonStats
  def all_teams_in_post_season(season_id)
    @teams.values.find_all do |team_object|
      if team_object.seasons_hash.keys.include?(season_id)
        season_object = team_object.seasons_hash[season_id]
        season_object.total_post_game_count != 0
      else
        false
      end
    end
  end

  def biggest_bust(season_id)
    all_teams_in_post_season(season_id).max_by do |team_object|
      season_object = team_object.seasons_hash[season_id]
      season_object.reg_seas_win_percentage - season_object.post_seas_win_percentage
    end.team_name
  end

  def biggest_surprise(season_id)
    all_teams_in_post_season(season_id).min_by do |team_object|
      season_object = team_object.seasons_hash[season_id]
      season_object.reg_seas_win_percentage - season_object.post_seas_win_percentage
    end.team_name
  end

  def all_season_objects(season_id)
    team_objects = @teams.values.find_all do |team_object|
      team_object.seasons_hash.keys.include?(season_id)
    end
    team_objects.map do |team_object|
      team_object.seasons_hash[season_id]
    end
  end

  def most_hits(season_id)
    max_hit_season = all_season_objects(season_id).max_by do |season_object|
      season_object.total_hits
    end
    max_hit_season.team_name
  end

  def fewest_hits(season_id)
    min_hit_season = all_season_objects(season_id).min_by do |season_object|
      season_object.total_hits
    end
    min_hit_season.team_name
  end

  def power_play_goal_percentage(season_id)
    # TO DO
  end

end
