class SearchCacheManager
    def self.fetch_or_store(key, &block)
        Rails.cache.fetch(key, expires_in: 1.hour, &block)
    end
end
  