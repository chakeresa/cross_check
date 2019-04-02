require './test/test_helper'

class GameTest < Minitest::Test
  def setup
    @game_stats = StatTracker.games("data/dummy/game_mini.csv")
    @game = @game_stats[2012030221]
  end

  def test_game_class_exists
    assert_instance_of Game, @game
  end

  def test_game_has_attributes
    assert_equal 2012030221, @game.game_id
    assert_equal 20122013, @game.season
    assert_equal "P", @game.type
    assert_equal 3, @game.away_team_id
    assert_equal 6, @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
    assert_equal "home win OT", @game.outcome
  end

  def test_total_goals_sums_home_and_away_goals
    assert_equal 5, @game.total_goals
  end

end
