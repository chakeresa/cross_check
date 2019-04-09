require './test/test_helper'

class SeasonTest < Minitest::Test
  def setup
    @locations = {
      games: "data/dummy/game_med.csv",
      teams: "data/dummy/team_info_med.csv",
      game_teams: "data/dummy/game_teams_stats_med.csv"
    }
    @stats = StatTracker.from_csv(@locations)
    @team = @stats.teams[5]
    @season = Season.new(@team, 20152016)
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_generate_regular_seas_games_returns_hash_w_home_and_away_game_objects
    assert_equal 0, @season.generate_regular_seas_games[:home].count
    assert_equal 2, @season.generate_regular_seas_games[:away].count
  end

  def test_generate_post_seas_games_returns_hash_w_home_and_away_game_objects
    assert_equal 1, @season.generate_post_seas_games[:home].count
    assert_equal 2, @season.generate_post_seas_games[:away].count
  end
end
