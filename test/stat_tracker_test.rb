require './test/test_helper'

class StatTrackerTest < Minitest::Test
  def setup
    @locations = {
      games: "data/dummy/game_mini.csv",
      teams: "data/team_info.csv",
      game_teams: "data/dummy/game_teams_stats_mini.csv"
    }
    @stats = StatTracker.from_csv(@locations)
    @med_locations = {
      games: "data/dummy/game_med.csv",
      teams: "data/dummy/team_info_med.csv",
      game_teams: "data/dummy/game_teams_stats_med.csv"
    }
    @med_stats = StatTracker.from_csv(@med_locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stats
  end

  def test_from_csv_returns_a_hash_of_hashes
    assert_equal 15, @stats.games.length
    assert_equal 33, @stats.teams.length
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

  # LeagueStats module tests
  def test_count_of_teams_returns_total_number_of_unique_team_names_in_data
    assert_equal 33, @stats.count_of_teams
  end

  def test_best_offense_returns_team_name_with_highest_average_goals
    assert_equal "Capitals", @med_stats.best_offense
  end

  def test_worst_offense_returns_team_name_with_lowest_average_goals
    assert_equal "Predators", @med_stats.worst_offense
  end

  def test_best_defense_returns_team_name_with_lowest_average_opponent_goals
    assert_equal "Sharks", @med_stats.best_defense
  end

  def test_worst_defense_returns_team_name_with_highest_average_opponent_goals
    assert_equal "Capitals", @med_stats.worst_defense
  end

  def test_highest_scoring_visitor_returns_name_of_team_with_highest_average_score_across_all_seasons_when_away
    assert_equal "Sharks", @med_stats.highest_scoring_visitor
  end

  def test_highest_scoring_home_team_returns_name_of_team_with_highest_average_score_across_all_seasons_when_home
    assert_equal "Penguins", @med_stats.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor_returns_name_of_team_with_lowest_average_score_across_all_seasons_when_away
    assert_equal "Predators", @med_stats.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team_returns_name_of_team_with_lowest_average_score_across_all_seasons_when_home
    assert_equal "Capitals", @med_stats.lowest_scoring_home_team
  end

  def test_winningest_team_returns_name_of_team_with_highest_win_percent_of_all_time
    assert_equal "Sharks", @med_stats.winningest_team
  end

  def test_best_fans_returns_name_of_team_with_largest_diff_bw_home_and_away_win_percent
    assert_equal "Predators", @med_stats.best_fans
  end

  def test_worst_fans_returns_ary_of_all_teams_w_better_away_than_home_win_percent
    assert_equal ["Capitals"], @med_stats.worst_fans
  end

  # TeamStats module tests
  def test_team_info_hash_has_key_value_pairs_for_each_attribute_for_team
    expected = {
      "team_id" => "15",
      "franchise_id" => "24",
      "short_name" => "Washington",
      "team_name" => "Capitals",
      "abbreviation" => "WSH",
      "link" => "/api/v1/teams/15"
    }
    assert_equal expected, @med_stats.team_info("15")
  end

  def test_win_percentage_for_season_returns_win_fraction_float
    predators = @med_stats.teams[18]
    assert_equal 0.33, @med_stats.win_percentage_for_season(predators, "20142015")
  end

  def test_all_season_ids_returns_array_of_all_seasons
    expected = ["20142015", "20152016", "20162017", "20172018"]
    assert_equal expected, @med_stats.all_season_ids("18")
  end

  def test_best_season_returns_season_with_the_highest_win_percentage_for_team
    assert_equal "20162017", @med_stats.best_season("5")
  end

  def test_worst_season_returns_season_with_the_lowest_win_percentage_for_team
    assert_equal "20142015", @med_stats.worst_season("18")
  end

  def test_average_win_percentage_of_all_games_for_team
    assert_equal 0.69, @med_stats.average_win_percentage("28")
  end

  def test_goals_for_team_in_game_returns_number_of_goals_for_team_in_a_game
    predators = mock("predators")
    predators.stubs(:team_id).returns(18)
    sharks = mock("sharks")
    sharks.stubs(:team_id).returns(28)
    game1 = mock("game1")
    goals_hash = {home: 5, away: 7}
    team_id_hash = {home: 18, away: 28}
    game1.stubs(:goals).returns(goals_hash)
    game1.stubs(:team_ids).returns(team_id_hash)
    assert_equal 5, @med_stats.goals_for_team_in_game(predators, game1)
    assert_equal 7, @med_stats.goals_for_team_in_game(sharks, game1)
  end

  def test_most_goals_scored_in_a_single_game_for_team
    assert_equal 7, @med_stats.most_goals_scored("15")
  end

  def test_fewest_goals_scored_in_a_single_game_for_team
    assert_equal 0, @med_stats.fewest_goals_scored("5")
  end

  def test_favorite_opponent_returns_opponent_with_lowest_win_percentage_against_team
    assert_equal "Capitals", @med_stats.favorite_opponent("18")
  end

  def test_rival_returns_opponent_with_lowest_win_percentage_against_team
    assert_equal "Penguins", @med_stats.rival("18")
  end

  def test_all_opponent_team_ids_returns_opponent_team_ids_array
    assert_equal [5, 15, 28], @med_stats.all_opponent_team_ids(18)
  end

  def test_win_percentage_for_opponent_returns_win_fraction_float_between_teams
    predators = @med_stats.teams[18]
    assert_equal 0.25, @med_stats.win_percentage_for_opponent(predators, 5)
  end

  def test_team_and_opp_goal_difference_return_array_of_game_goal_differences
    expected = [-3, 1, 1, 3, -2, 6, -2, 1, -2, 2, 3, 1, -4, -1, -1, 2]
    assert_equal expected, @med_stats.team_and_opp_goal_difference("5")
  end

  def test_biggest_team_blowout_returns_biggest_difference_between_team_goals_minus_opponent_goals
    assert_equal 6, @med_stats.biggest_team_blowout("5")
  end

  def test_worst_loss_returns_biggest_difference_between_opponent_goals_minus_team_goals
    assert_equal 4, @med_stats.worst_loss("5")
  end

  def test_head_to_head_returns_a_hash_with_opponent_name_as_key_and_win_pc_as_value
    expected = {
        "Penguins" => 0.25,
        "Capitals" => 0.75,
        "Sharks" => 0.38
    }
    assert_equal expected, @med_stats.head_to_head("18")
  end

  def test_seasonal_summary_returns_hash_that_has_two_keys_with_reg_and_post_season_stats_keys_with_values
    skip
    regular_season_hash2014 = {
      win_percentage: 0.33,
      total_goals_scored: 7,
      total_goals_against: 2,
      average_goals_scored: 2.33,
      average_goals_against: 0.66
    }
    postseason_hash2014 = {
      win_percentage: 0,
      total_goals_scored: 0,
      total_goals_against: 0,
      average_goals_scored: 0,
      average_goals_against: 0
    }
    regular_season_hash2015 = {
      win_percentage: 1.0,
      total_goals_scored: 6,
      total_goals_against: 4,
      average_goals_scored: 3,
      average_goals_against: 2
    }
    postseason_hash2015 = {
      win_percentage: 0.33,
      total_goals_scored: 6,
      total_goals_against: 9,
      average_goals_scored: 2,
      average_goals_against: 3
    }
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
    regular_season_hash2017 = {
      win_percentage: 0.5,
      total_goals_scored: 8,
      total_goals_against: 7,
      average_goals_scored: 4,
      average_goals_against: 3.5
    }
    postseason_hash2017 = {
      win_percentage: 0,
      total_goals_scored: 0,
      total_goals_against: 0,
      average_goals_scored: 0,
      average_goals_against: 0
    }
    expected = {
        "20142015" => { regular_season: regular_season_hash2014,
                        postseason: postseason_hash2014},
        "20152016" => { regular_season: regular_season_hash2015,
                        postseason: postseason_hash2015},
        "20162017" => { regular_season: regular_season_hash2016,
                        postseason: postseason_hash2016},
        "20172018" => { regular_season: regular_season_hash2017,
                        postseason: postseason_hash2017}
    }
    assert_equal expected, @med_stats.seasonal_summary("5")
  end
end
