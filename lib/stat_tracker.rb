require 'csv'
require_relative 'game_stats'
require_relative 'league_stats'
require_relative 'team_stats'
require_relative 'game'
require_relative 'team'
require_relative 'csv_loader'

class StatTracker
  include GameStats
  include LeagueStats
  include TeamStats

  attr_reader :games,
              :teams,
              :game_teams # TO DO: delete after team is refactored

  def initialize(all_files)
    @games = all_files[:games]
    @teams = all_files[:teams]
    @game_teams = all_files[:game_teams] # TO DO: delete after team is refactored
  end

  def self.from_csv(locations)
    csv_loader = CsvLoader.new(locations)
    StatTracker.new(csv_loader.export)
  end

end
