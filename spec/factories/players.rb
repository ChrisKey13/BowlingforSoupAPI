FactoryBot.define do
  factory :player do
    name { Faker::Name.name }
    game_session

    trait :with_game do
      after(:create) do |player|
        create(:game, player: player)
      end
    end
  end
end
