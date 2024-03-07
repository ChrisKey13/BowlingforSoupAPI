FactoryBot.define do
  factory :game_session do
    trait :with_players do
      after(:create) do |game_session|
        create_list(:player, 3, game_session: game_session)
      end
    end

    trait :game_session_with_scored_games do
      after(:create) do |game_session|
        players = create_list(:player, 3, game_session: game_session)
        players.each_with_index do |player, index|
          score = index * 10 + 100  # This ensures the last player has the highest score
          create(:game, player: player, total_score: score, game_session_id: game_session.id)
        end
      end
    end

    trait :with_tied_games do
      after(:create) do |game_session|
        players = create_list(:player, 2, game_session: game_session)
        tied_score = 100
    
        players.each do |player|
          game = create(:game, player: player, total_score: tied_score, game_session_id: player.game_session.id)
          game.update!(total_score: tied_score)
          puts "Creating tied game for Player #{player.id} with total_score: #{game.total_score}"
          puts "Let inspect that game #{game.inspect}"
        end

        game_session.players.reload
        game_session.games.reload
    
        puts "Debugging Factory - GameSession ID: #{game_session.id}, Games Count: #{game_session.games.count}"
        game_session.games.each_with_index do |game, index|
          puts "Debugging Factory - Game #{index + 1}: ID: #{game.id}, Score: #{game.total_score}, Player ID: #{game.player_id}, GameSession ID: #{game.game_session.id}"
        end
      end
    end
    
  end
end
