require './test/test_helper'

class StatTrackerTest < Minitest::Test
  def setup
    @team_stats = StatTracker.teams("data/team_info.csv", "data/dummy/game_teams_stats_mini.csv")
    @game_stats = StatTracker.games("data/dummy/game_mini.csv")
    @game_team_stats = StatTracker.game_teams("data/dummy/game_teams_stats_mini.csv")
    @locations = {
      games: "data/dummy/game_mini.csv",
      teams: "data/team_info.csv",
      game_teams: "data/dummy/game_teams_stats_mini.csv"
    }
    @stats = StatTracker.from_csv(@locations)
    @med_locations = {
      games: "data/dummy/game_mini.csv", # TO DO: haven't made med - use mini
      teams: "data/dummy/team_info_med.csv",
      game_teams: "data/dummy/game_teams_stats_med.csv"
    }
    @med_stats = StatTracker.from_csv(@med_locations)
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
    assert_equal 15, @stats.games.length
    assert_equal 33, @stats.teams.length
    assert_equal 30, @stats.game_teams.length
  end

  # GameStats module tests
  def test_highest_total_score
    assert_equal 8, @stats.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stats.lowest_total_score
  end

  def test_biggest_blowout_returns_largest_difference_in_scores
    assert_equal 5, @stats.biggest_blowout
  end

  def test_percentage_home_wins_returns_fraction_of_all_games_won_by_home_team
    assert_equal 0.73, @stats.percentage_home_wins
  end

  def test_percentage_visitor_wins_returns_fraction_of_all_games_won_by_away_team
    assert_equal 0.27, @stats.percentage_visitor_wins
  end

  def test_count_of_games_by_season_returns_hash_of_seasons_and_corresponding_games
    expected = {
      "20122013" => 7,
      "20132014" => 5,
      "20172018" => 1,
      "20152016" => 2
    }
    assert_equal expected, @stats.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 4.60, @stats.average_goals_per_game
  end

  def test_count_of_goals_by_season_returns_hash_of_seasons_and_corresponding_goals
    expected = {
      "20122013" => 36,
      "20132014" => 22,
      "20172018" => 3,
      "20152016" => 8
    }
    assert_equal expected, @stats.count_of_goals_by_season
  end

  def test_average_goals_by_season
    expected = {
      "20122013" => 5.14,
      "20132014" => 4.40,
      "20172018" => 3.00,
      "20152016" => 4.00
    }
    assert_equal expected, @stats.average_goals_by_season
  end

  # TeamStats module tests
  def test_count_of_teams_returns_total_number_of_unique_team_names_in_data
    assert_equal 32, @stats.count_of_teams
  end

  def test_best_offense_returns_team_name_with_highest_average_goals
    assert_equal "Blackhawks", @stats.best_offense
  end

  def test_winningest_team_returns_name_of_team_with_highest_win_percent_of_all_time
    assert_equal "Lightning", @med_stats.winningest_team
  end

  def test_best_fans_returns_name_of_team_with_largest_diff_bw_home_and_away_win_percent
    assert_equal "Lightning", @med_stats.best_fans
  end

  def test_worst_fans_returns_ary_of_all_teams_w_better_away_than_home_win_percent
    assert_equal ["Flyers"], @med_stats.worst_fans
  end

end
