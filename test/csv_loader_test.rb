require './test/test_helper'

class CsvLoaderTest < Minitest::Test
  def setup
    @med_locations = {
      games: "data/dummy/game_med.csv",
      teams: "data/dummy/team_info_med.csv",
      game_teams: "data/dummy/game_teams_stats_med.csv"
    }
    @med_stats = CsvLoader.new(@med_locations)
  end

  def test_it_exists
    assert_instance_of CsvLoader, @med_stats
  end

  def test_it_inits_w_3_filepaths
    assert_equal @med_locations[:games], @med_stats.game_csv_filepath
    assert_equal @med_locations[:teams], @med_stats.team_info_csv_filepath
    assert_equal @med_locations[:game_teams], @med_stats.game_teams_info_csv_filepath
  end

  def test_create_game_teams_hash_inits_game_teams_hash_ivar
    assert_equal @med_stats.create_game_teams_hash, @med_stats.game_teams_hash
  end

  def test_create_game_teams_hash_has_keys_of_game_id_plus_hoa_and_values_of_game_teams_stats_row
    game_teams_hash_1 = @med_stats.create_game_teams_hash
    away_game = game_teams_hash_1["2016020007-away"]
    home_game = game_teams_hash_1["2014020990-home"]

    assert_equal 59.4, away_game[:faceoffwinpercentage]
    assert_equal 45.6, home_game[:faceoffwinpercentage]
    assert_instance_of CSV::Row, away_game
  end

  def test_teams_makes_a_hash_with_team_id_as_keys
    skip
    assert_instance_of Hash, @team_stats
    assert_equal 1, @team_stats.keys[0]
    assert_equal 4, @team_stats.keys[1]
  end

  def test_games_makes_a_hash_with_game_id_as_keys
    skip
    assert_instance_of Hash, @game_stats
    assert_equal 2012030221, @game_stats.keys[0]
    assert_equal 2012030222, @game_stats.keys[1]
  end

  def test_game_teams_makes_a_hash_with_game_id_and_HoA_as_keys
    skip
    assert_instance_of Hash, @game_team_stats
    assert_equal "2012030221-away", @game_team_stats.keys[0]
    assert_equal "2012030221-home", @game_team_stats.keys[1]
  end

  def test_from_csv_returns_a_hash_of_hashes
    skip
    assert_equal 15, @stats.games.length
    assert_equal 33, @stats.teams.length
    assert_equal 30, @stats.game_teams.length
  end
end
