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

  def test_game_stats_for_game_returns_hash_of_game_teams_for_only_that_game
    mock_game = {game_id: "2014020990"}
    hoa_data = @med_stats.game_stats_for_game(mock_game)

    assert_equal [:home, :away], hoa_data.keys
    assert_equal 45.6, hoa_data[:home][:faceoffwinpercentage]
    assert_equal 17, hoa_data[:away][:giveaways]
  end

  def test_create_game_hash_has_keys_of_game_id_and_values_of_game_objects
    game_hash_1 = @med_stats.create_game_hash
    single_game = game_hash_1[2015021206]

    assert_equal 2015021206, game_hash_1.keys[1]
    assert_instance_of Game, single_game
    assert_equal ({home: 15, away: 5}), single_game.team_ids
    assert_equal ({home: 14, away: 12}), single_game.takeaways

    game_hash_attr = @med_stats.game_hash
    single_game_from_attr = game_hash_attr[2015021206]

    assert_equal 2015021206, game_hash_attr.keys[1]
    assert_instance_of Game, single_game_from_attr
    assert_equal ({home: 15, away: 5}), single_game_from_attr.team_ids
    assert_equal ({home: 14, away: 12}), single_game_from_attr.takeaways
  end

  def test_games_for_team_returns_hash_of_games_for_only_that_team
    mock_team = {team_id: 28}
    games_for_mock_team = @med_stats.games_for_team(mock_team)

    assert_instance_of Hash, games_for_mock_team
    assert_equal 16, games_for_mock_team.count
    assert_equal 2014020990, games_for_mock_team.keys.first
    assert_equal 51.4, games_for_mock_team[2015030415].face_off_win_percentage[:away]
  end

  def test_create_team_hash_has_keys_of_team_id_and_values_of_team_objects
    team_hash_1 = @med_stats.create_team_hash
    single_team = team_hash_1[18]

    assert_equal [5, 15, 18, 28], team_hash_1.keys.sort
    assert_equal 4, team_hash_1.count
    assert_instance_of Team, single_team
    assert_equal 34, single_team.franchise_id
    assert_equal 16, single_team.total_game_count

    team_hash_attr = @med_stats.team_hash
    single_team_from_attr = team_hash_attr[18]

    assert_equal [5, 15, 18, 28], team_hash_attr.keys.sort
    assert_equal 4, team_hash_attr.count
    assert_instance_of Team, single_team_from_attr
    assert_equal 34, single_team_from_attr.franchise_id
    assert_equal 16, single_team_from_attr.total_game_count
  end
end
