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
    assert_equal 27, @team.games[2012030312].shots[:home]
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
