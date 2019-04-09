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

  def test_reg_seas_total_goals_returns_hash_of_goals_for_and_against
    assert_equal 12, @season.reg_seas_total_goals[:scored]
    assert_equal 14, @season.reg_seas_total_goals[:against]
  end

  def test_post_seas_total_goals_scored_returns_integer
    assert_equal 10, @season.post_seas_total_goals[:scored]
    assert_equal 4, @season.post_seas_total_goals[:against]
  end

  def test_total_game_counts_return_integers
    assert_equal 3, @season.total_regular_game_count
    assert_equal 3, @season.total_post_game_count
    assert_equal 6, @season.total_game_count
  end

  def test_reg_seas_avg_goals_per_game_returns_hash_for_scored_and_against
    assert_equal 4.0, @season.reg_seas_avg_goals_per_game[:scored]
    assert_equal 4.67, @season.reg_seas_avg_goals_per_game[:against]
  end

  def test_post_seas_avg_goals_per_game_returns_hash_for_scored_and_against
    assert_equal 3.33, @season.post_seas_avg_goals_per_game[:scored]
    assert_equal 1.33, @season.post_seas_avg_goals_per_game[:against]
  end

  def test_summary_returns_superhash
    regular_season_hash2016 = {
      win_percentage: 0.67,
      total_goals_scored: 12,
      total_goals_against: 14,
      average_goals_scored: 4,
      average_goals_against: 4.67
    }
    postseason_hash2016 = {
      win_percentage: 0.67,
      total_goals_scored: 10,
      total_goals_against: 4,
      average_goals_scored: 3.33,
      average_goals_against: 1.33
    }
    expected = {regular_season: regular_season_hash2016, postseason: postseason_hash2016}

    assert_equal expected, @season.summary
  end

  def test_total_hits_returns_total_number_of_hits_in_season
    assert_equal 175, @season.total_hits
  end

  def test_total_power_play_goals_returns_total_number_of_pp_goals_in_season
    assert_equal 4, @season.total_power_play_goals
  end
end
