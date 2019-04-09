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
    @season = Season.new(@team, 20162017)
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_generate_regular_seas_games_returns_hash_w_home_and_away_game_objects
    assert_equal 2, @season.generate_regular_seas_games(@team)[:home].count
    assert_equal 1, @season.generate_regular_seas_games(@team)[:away].count
  end

  def test_generate_post_seas_games_returns_hash_w_home_and_away_game_objects
    assert_equal 1, @season.generate_post_seas_games(@team)[:home].count
    assert_equal 2, @season.generate_post_seas_games(@team)[:away].count
  end

  def test_generate_all_games_returns_hash_w_home_and_away_game_objects
    assert_equal 3, @season.generate_all_games[:home].count
    assert_equal 3, @season.generate_all_games[:away].count
  end

  def test_reg_seas_win_percentage_returns_frac_of_games_won
    assert_equal 0.67, @season.reg_seas_win_percentage
  end

  def test_post_seas_win_percentage_returns_frac_of_games_won
    assert_equal 0.67, @season.post_seas_win_percentage
  end

  def test_post_seas_total_goals_scored_returns_integer
    assert_equal 10, @season.post_seas_total_goals_scored
  end

  def test_total_game_count_returns_integer
    assert_equal 6, @season.total_game_count
  end
end
