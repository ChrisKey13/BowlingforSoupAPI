module SearchComponents
    class MustQuery
        def self.build(query, fields)
            {
                multi_match: {
                    query: query.strip,
                    fields: fields,
                    fuzziness: "AUTO"
                }
            }    
        end
    end
end