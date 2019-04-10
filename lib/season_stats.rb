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

  def all_game_objects(season_object)
    season_object.all_games.values.flatten
  end

  def all_coach_names(season_id)
    season_objects = all_season_objects(season_id)
    all_coaches = season_objects.flat_map do |season_object|
      all_game_objects(season_object).flat_map { |game| game.coaches.values }
    end.uniq
  end

  def coach_winning_percentages(season_id)
    season_objects = all_season_objects(season_id)
    all_coaches = all_coach_names(season_id)
    hash = Hash.new(0)
    all_coaches.each do |coach|
      win_count = 0; loss_count = 0
      season_objects.each do |season_object|
        all_game_objects(season_object).each do |game|
          if (coach == game.coaches[:home] && game.home_win) || (coach == game.coaches[:away] && !game.home_win)
            win_count += 0.5
          elsif (coach == game.coaches[:home] && !game.home_win) || (coach == game.coaches[:away] && game.home_win)
            loss_count += 0.5
          end
        end
      end
      win_pct = win_count / (win_count + loss_count)
      hash[coach] = win_pct
    end
    hash
  end

  def winningest_coach(season_id)
    hash = coach_winning_percentages(season_id)
    hash.each {|coach, pct| return coach if pct == hash.values.max}
  end

  def worst_coach(season_id)
    hash = coach_winning_percentages(season_id)
    hash.each {|coach, pct| return coach if pct == hash.values.min}

  def most_accurate_team(season_id)
    most_accurate = all_season_objects(season_id).max_by do |season_object|
      season_object.goals_per_shots_ratio
    end
    most_accurate.team_name
  end

  def least_accurate_team(season_id)
    least_accurate = all_season_objects(season_id).min_by do |season_object|
      season_object.goals_per_shots_ratio
    end
    least_accurate.team_name
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
    all_power_play_goals = all_season_objects(season_id).sum do |season_object|
      season_object.total_power_play_goals
    end
    all_goals_wo_shootout = all_season_objects(season_id).sum do |season_object|
      season_object.total_goals_wo_shootout
    end
    (all_power_play_goals.to_f / all_goals_wo_shootout).round(2)
  end

end
