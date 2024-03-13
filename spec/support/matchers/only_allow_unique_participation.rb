RSpec::Matchers.define :only_allow_unique_participation_for_team do
    match do |game_session|
      duplicate_participation = Participation.new(team: @team, game_session: game_session)
      duplicate_participation.save
  
      @already_exists = duplicate_participation.persisted? == false && duplicate_participation.errors[:team_id].include?("has already been taken")
  
      @allows_creation = Participation.where(team: @team, game_session: game_session).count == 1 && duplicate_participation.errors[:team_id].empty?
  
      @already_exists || @allows_creation
    end
  
    chain :for_team do |team|
      @team = team
    end
  
    failure_message do
      if @already_exists
        "expected that no duplicate participation for team #{@team} in the given game session is allowed, but it was permitted"
      elsif @allows_creation
        "expected that creating a participation for team #{@team} when none exists should be allowed, but it was not"
      else
        "expected that the participation for team #{@team} respects the unique constraint, but the constraint was violated"
      end
    end
  
    failure_message_when_negated do
      "expected that the participation for team #{@team} does not respect the unique constraint, but it was respected"
    end
  end
  