class Game
  attr_reader :game_id,
              :season,
              :type,
              :team_ids,
              :goals,
              :goals_wo_shootout,
              :home_win,
              :settled_in,
              :shots,
              :hits,
              :pim,
              :power_play_opportunities,
              :power_play_goals,
              :face_off_win_percentage,
              :giveaways,
              :takeaways,
              :coaches

  def initialize(game_info, relevant_game_team_stats)
    @game_id = game_info[:game_id]
    @season = game_info[:season].to_s
    @type = game_info[:type]
    @team_ids = {home: game_info[:home_team_id], away: game_info[:away_team_id]}
    @goals = {home: game_info[:home_goals], away: game_info[:away_goals]}
    @goals_wo_shootout = {home: relevant_game_team_stats[:home][:goals], away: relevant_game_team_stats[:away][:goals]}
    @home_win = game_info[:outcome].split[0] == "home"
    @settled_in = game_info[:outcome].split[2]
    @coaches = {home: relevant_game_team_stats[:home][:head_coach], away: relevant_game_team_stats[:away][:head_coach]}
    @shots = {home: relevant_game_team_stats[:home][:shots], away: relevant_game_team_stats[:away][:shots]}
    @hits = {home: relevant_game_team_stats[:home][:hits], away: relevant_game_team_stats[:away][:hits]}
    @pim = {home: relevant_game_team_stats[:home][:pim], away: relevant_game_team_stats[:away][:pim]}
    @power_play_opportunities = {home: relevant_game_team_stats[:home][:powerplayopportunities], away: relevant_game_team_stats[:away][:powerplayopportunities]}
    @power_play_goals = {home: relevant_game_team_stats[:home][:powerplaygoals], away: relevant_game_team_stats[:away][:powerplaygoals]}
    @face_off_win_percentage = {home: relevant_game_team_stats[:home][:faceoffwinpercentage], away: relevant_game_team_stats[:away][:faceoffwinpercentage]}
    @giveaways = {home: relevant_game_team_stats[:home][:giveaways], away: relevant_game_team_stats[:away][:giveaways]}
    @takeaways = {home: relevant_game_team_stats[:home][:takeaways], away: relevant_game_team_stats[:away][:takeaways]}
  end

  def total_goals
    @goals.values.sum
  end
end
