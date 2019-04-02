require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    @stats = StatTracker.new
    @team_stats = @stats.teams("data/team_info.csv")
    @game_stats = @stats.games("data/game.csv")
    @game_team_stats = @stats.game_teams("data/game_teams_stats.csv")
  end

  def test_it_exists
    assert_instance_of StatTracker, @stats
  end

  def test_teams_makes_a_hash_with_team_id_as_keys
    assert_instance_of Hash, @team_stats
    assert_equal 1, @team_stats.keys[0]
    assert_equal 4, @team_stats.keys[1]
  end

  def test_games_makes_a_hash_with_game_id_as_keys
    assert_instance_of Hash, @game_stats
    assert_equal 2012030221, @game_stats.keys[0]
    assert_equal 2012030222, @game_stats.keys[1]
  end

  def test_game_teams_makes_a_hash_with_game_id_and_HoA_as_keys
    assert_instance_of Hash, @game_team_stats
    assert_equal "2012030221-away", @game_team_stats.keys[0]
    assert_equal "2012030221-home", @game_team_stats.keys[1]
  end
end
