class CsvLoader
  attr_reader :game_csv_filepath,
              :team_info_csv_filepath,
              :game_teams_info_csv_filepath,
              :game_teams_hash,
              :game_hash,
              :team_hash

  def initialize(locations)
    @game_csv_filepath = locations[:games]
    @team_info_csv_filepath = locations[:teams]
    @game_teams_info_csv_filepath = locations[:game_teams]
    @game_teams_hash = create_game_teams_hash
    @game_hash = create_game_hash
    @team_hash = create_team_hash
  end

  def create_game_teams_hash
    game_team_data = CSV.table(@game_teams_info_csv_filepath)
    game_team_data.inject({}) do |game_team_hash_builder, game_team_row|
      new_key = game_team_row[:game_id].to_s + "-" + game_team_row[:hoa].to_s
      game_team_hash_builder[new_key] = game_team_row
      game_team_hash_builder
    end
  end

  def game_stats_for_game(game)
    single_game_id = game[:game_id]
    hash = Hash.new
    hash[:home] = @game_teams_hash[single_game_id.to_s + "-" + "home"]
    hash[:away] = @game_teams_hash[single_game_id.to_s + "-" + "away"]
    hash
  end

  def create_game_hash
    game_data = CSV.table(@game_csv_filepath)
    game_data.inject({}) do |game_hash_builder, game|
      relevant_game_team_stats = game_stats_for_game(game)
      game_hash_builder[game[:game_id]] = Game.new(game, relevant_game_team_stats)
      game_hash_builder
    end
  end

  def game_stats_for_team(team)
    single_team_id = team[:team_id]
    relevant_game_team_hash = @game_teams_hash.clone
    relevant_game_team_hash.keep_if do |uniq_game_id, row|
      row[:team_id] == single_team_id
    end
  end

  def create_team_hash
    team_data = CSV.table(@team_info_csv_filepath)
    team_data.inject({}) do |team_hash_builder, team|
      relevant_game_team_stats = game_stats_for_team(team)
      team_hash_builder[team[:team_id]] = Team.new(team, relevant_game_team_stats)
      team_hash_builder
    end
  end



  #
  # def load_all(locations)
  #   all_files = {}
  #   all_files[:games] = create_games(locations[:games], locations[:game_teams])
  #   all_files[:teams] = create_teams(locations[:teams], locations[:game_teams])
  #   all_files[:game_teams] = create_game_teams(locations[:game_teams])
  #   StatTracker.new(all_files)
  # end
end
