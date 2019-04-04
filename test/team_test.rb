require './test/test_helper'

class TeamTest < Minitest::Test
  def setup
    @team_stats = StatTracker.teams("data/team_info.csv", "data/dummy/game_teams_stats_mini.csv")
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
    assert_equal 27, @team.games["2012030312-home"][:shots]
  end

end
