require 'csv'
require_relative 'game_stats'
require_relative 'league_stats'
require_relative 'game'
require_relative 'team'

class StatTracker
  include GameStats
  include LeagueStats

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(all_files)
    @games = all_files[:games]
    @teams = all_files[:teams]
    @game_teams = all_files[:game_teams]
  end

  def self.teams(teams_filepath, team_games_filepath)
    team_data = CSV.table(teams_filepath)
    team_data.inject({}) do |team_hash, team|
      relevant_game_team_stats = self.game_stats_for_team(team, team_games_filepath)
      team_hash[team[:team_id]] = Team.new(team, relevant_game_team_stats)
      team_hash
    end
  end

  def self.game_stats_for_team(team, filepath)
    single_team_id = team[:team_id]
    self.game_teams(filepath).keep_if do |uniq_game_id, row|
      row[:team_id] == single_team_id
    end
  end

  def self.games(filepath)
    game_data = CSV.table(filepath)
    game_data.inject({}) do |game_hash, game|
      game_hash[game[:game_id]] = Game.new(game)
      game_hash
    end
  end

  def self.game_teams(filepath)
    game_team_data = CSV.table(filepath)
    game_team_data.inject({}) do |game_team_hash, game_team_row|
      new_key = game_team_row[:game_id].to_s + "-" + game_team_row[:hoa].to_s
      game_team_hash[new_key] = game_team_row
      game_team_hash
    end
  end

  def self.from_csv(locations)
    all_files = {}
    all_files[:games] = self.games(locations[:games])
    all_files[:teams] = self.teams(locations[:teams], locations[:game_teams])
    all_files[:game_teams] = self.game_teams(locations[:game_teams])
    StatTracker.new(all_files)
  end

end
