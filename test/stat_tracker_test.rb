require './test/test_helper'

class StatTrackerTest < Minitest::Test
  def setup
    @stats = StatTracker.new
    @team_stats = StatTracker.teams("data/team_info.csv")
    @game_stats = StatTracker.games("data/dummy/game_mini.csv")
    @game_team_stats = StatTracker.game_teams("data/dummy/game_teams_stats_mini.csv")
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

  def test_from_csv_returns_a_hash_of_hashes
    locations = {
      games: "data/dummy/game_mini.csv",
      teams: "data/team_info.csv",
      game_teams: "data/dummy/game_teams_stats_mini.csv"
    }

    actual = StatTracker.from_csv(locations)

    assert_equal 15, actual[:games].length
    assert_equal 33, actual[:teams].length
    assert_equal 14, actual[:game_teams].length
  end
end
