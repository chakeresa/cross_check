require './test/test_helper'

class TeamTest < Minitest::Test
  def setup
    @locations = {
      games: "data/dummy/game_mini.csv",
      teams: "data/dummy/team_info_mini.csv",
      game_teams: "data/dummy/game_teams_stats_mini.csv"
    }
    @stats = StatTracker.from_csv(@locations)
    @team_stats = @stats.teams
    @team = @team_stats[5]
  end

  def test_team_class_exists
    assert_instance_of Team, @team
  end

  def test_team_has_attributes
    assert_equal 5, @team.team_id
    assert_equal 17, @team.franchise_id
    assert_equal "Pittsburgh", @team.short_name
    assert_equal "Penguins", @team.team_name
    assert_equal "PIT", @team.abbreviation
    assert_equal "/api/v1/teams/5", @team.link
  end

  def test_team_has_games
    assert_instance_of Hash, @team.games
    assert_equal 2, @team.games[:home].count
    assert_equal 3, @team.games[:away].count
    assert_instance_of Game, @team.games[:home][0]
  end

  def test_generate_home_and_away_games_returns_hash_of_home_vs_away_game_objects
    game1 = mock("game1")
    game1.stubs(:team_ids).returns({home: 5, away: 15})
    game2 = mock("game2")
    game2.stubs(:team_ids).returns({home: 5, away: 18})
    game3 = mock("game3")
    game3.stubs(:team_ids).returns({home: 28, away: 5})
    games_hash = {2012030312 => game1, 2013051204 => game2, 2017041309 => game3}

    expected = {home: [game1, game2], away: [game3]}

    assert_equal expected, @team.generate_home_and_away_games(games_hash)
  end

  def test_generate_season_hash_returns_hash_with_season_id_keys_and_season_object_values
    assert_equal 2, @team.generate_seasons_hash.count
    assert_equal 2, @team.seasons_hash.count
  end

  def test_home_win_count
    team2 = @team_stats[6]
    assert_equal 5, team2.home_win_count
  end

  def test_home_loss_count
    assert_equal 2, @team.home_loss_count
  end

  def test_away_win_count
    assert_equal 1, @team.away_win_count
  end

  def test_away_loss_count
    assert_equal 2, @team.away_loss_count
  end
end
