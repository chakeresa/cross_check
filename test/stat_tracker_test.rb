require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    stats = StatTracker.new

    assert_instance_of StatTracker, stats
  end

  def test_teams_makes_a_hash_with_team_id_as_keys
    stats = StatTracker.new
    team_stats = stats.teams("data/team_info.csv")

    assert_instance_of Hash, team_stats
    assert_equal 1, team_stats.keys[0]
    assert_equal 4, team_stats.keys[1]
  end
end
