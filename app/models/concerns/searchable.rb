module Searchable
    extend ActiveSupport::Concern

    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks
    end

    def as_indexed_json(option={})
        as_json(only: [:name, :created_at, :updated_at])
    end
end