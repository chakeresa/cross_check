require './test/test_helper'

class GameTest < Minitest::Test
  def setup
    @game_stats = StatTracker.create_games("data/dummy/game_mini.csv", "data/dummy/game_teams_stats_mini.csv")
    @game = @game_stats[2012030221]
  end

  def test_game_class_exists
    assert_instance_of Game, @game
  end

  def test_game_has_attributes
    assert_equal 2012030221, @game.game_id
    assert_equal "20122013", @game.season
    assert_equal "P", @game.type
    assert_equal ({home: 6, away: 3}), @game.team_ids
    assert_equal ({home: 3, away: 2}), @game.goals
    assert_equal true, @game.home_win
    assert_equal "OT", @game.settled_in
  end

  def test_total_goals_sums_home_and_away_goals
    assert_equal 5, @game.total_goals
  end

end
