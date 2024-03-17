RSpec::Matchers.define :have_search_result do |expected|
    match do |actual|
        results = JSON.parse(actual.body)["results"]
        results.any? do |r|
            r["type"] == expected[:type] && r["attributes"]["name"].include?(expected[:name])
        end
    end
  
    failure_message do |actual|
        "expected that the search results would include a #{expected[:type]} with name including '#{expected[:name]}'"
    end
  end