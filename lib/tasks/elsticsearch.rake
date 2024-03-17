namespace :elasticsearch do
    desc 'Reindex all Elasticsearch models'
    task reindex: :environment do
      models = [GameSession, Game, Participation, Player, TeamPlayer, Team]
      models.each do |model|
        puts "Reindexing #{model.name}..."
        model.__elasticsearch__.create_index!(force: true) 
        model.import 
        puts "#{model.name} reindexed."
      end
    end
  end