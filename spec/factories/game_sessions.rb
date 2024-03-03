FactoryBot.define do
  factory :game_session do
    trait :with_players do
      after(:create) do |game_session|
        create_list(:player, 3, game_session: game_session)
      end
    end
  end
end
