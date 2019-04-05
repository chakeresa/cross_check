class Game
  attr_reader :game_id,
              :season,
              :type,
              :team_ids,
              :goals,
              :home_win,
              :settled_in

  def initialize(game_info)
    @game_id = game_info[:game_id]
    @season = game_info[:season].to_s
    @type = game_info[:type]
    @team_ids = {home: game_info[:home_team_id], away: game_info[:away_team_id]}
    @goals = {home: game_info[:home_goals], away: game_info[:away_goals]}
    @home_win = game_info[:outcome].split[0] == "home"
    @settled_in = game_info[:outcome].split[2]
  end

  def total_goals
    @goals.values.sum
  end

end
