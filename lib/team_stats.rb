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

  def all_opponent_team_ids(team_id)
    team_object = @teams[team_id.to_i]
    all_opp_team_ids = team_object.games.values.map do |game|
      if game.team_ids[:home] == team_id
        game.team_ids[:away]
      else
        game.team_ids[:home]
      end
    end.uniq
    all_opp_team_ids.delete(team_id.to_i)
    all_opp_team_ids
  end

  def win_percentage(team, opp_id)
    home_matches = 0
    away_matches = 0
    home_wins = 0
    away_wins = 0

    team.games.values.each do |game|
      if game.team_ids[:away] == opp_id
        home_matches += 1
        if game.home_win
          home_wins += 1
        end
      elsif game.team_ids[:home] == opp_id
        away_matches += 1
        if !game.home_win
          away_wins += 1
        end
      end
    end
    ((home_wins.to_f + away_wins) / (home_matches + away_matches)).round(2)
  end

  def favorite_opponent(team_id)
    head_to_head(team_id).max_by { |team_name, win_pct| win_pct }.first
  end

  def rival(team_id)
    head_to_head(team_id).min_by { |team_name, win_pct| win_pct }.first
  end

  def head_to_head(team_id)
    team_object = @teams[team_id.to_i]
    all_opp_team_ids = all_opponent_team_ids(team_id)
    hash = Hash.new(0)
    all_opp_team_ids.each do |opp_team_id|
      opponent_team_object = @teams[opp_team_id.to_i]
      hash[opponent_team_object.team_name] = win_percentage(team_object, opp_team_id)
    end
    hash
  end
end
