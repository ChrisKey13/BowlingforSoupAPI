RSpec::Matchers.define :have_search_result do |expected|
    match do |actual|
      results = JSON.parse(actual.body)["results"] 
      results.any? do |r|
        hit_type_matches = r["type"] == expected[:type]
        name_matches = r["_source"]["name"].include?(expected[:name])
        
        hit_type_matches && name_matches
      end
    end
  
    failure_message do |actual|
      "expected that the search results would include a #{expected[:type]} with name including '#{expected[:name]}'"
    end
  end
  