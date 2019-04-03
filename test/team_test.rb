require './test/test_helper'

class TeamTest < Minitest::Test
  def setup
    @team_stats = StatTracker.teams("data/team_info.csv")
    @team = @team_stats[1]
    # require "pry"; binding.pry
  end

  def test_team_class_exists
    assert_instance_of Team, @team
  end

  def test_team_has_attributes
    assert_equal 1, @team.team_id
    assert_equal 23, @team.franchise_id
    assert_equal "New Jersey", @team.short_name
    assert_equal "Devils", @team.team_name
    assert_equal "NJD", @team.abbreviation
    assert_equal "/api/v1/teams/1", @team.link
  end
end
