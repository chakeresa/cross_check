class Game
  attr_reader :game_id,
              :season,
              :type,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :outcome

  def initialize(game_info)
    @game_id = game_info[:game_id]
    @season = game_info[:season].to_s
    @type = game_info[:type]
    @away_team_id = game_info[:away_team_id]
    @home_team_id = game_info[:home_team_id]
    @away_goals = game_info[:away_goals]
    @home_goals = game_info[:home_goals]
    @outcome = game_info[:outcome]
  end

  def total_goals
    @away_goals + @home_goals
  end

end
