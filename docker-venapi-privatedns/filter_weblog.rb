require 'oj'
require 'fluent/filter'
require 'fluent/plugin'

## Filter plugin - flatten the weblog json
## @see https://docs.fluentd.org/v0.12/articles/plugin-development#filter-plugins

module Fluent
  class FilterWeblog < Filter
    Plugin.register_filter('filter_weblog', self)

    config_param :key_name, :string

    def initialize
      super
    end

    def configure(conf)
      super
    end

    def is_json(json)
      Oj.load(json)
        return true
      rescue Oj::ParseError => e
        return false
    end

    def filter(tag, time, record)
      log_hash = {}

      if record.has_key?(@key_name)
        raw_json = record[@key_name]
        raw_hash = Oj.load(raw_json)

        #-- flatten weblog
        #   weblog format => {"$k1":["$json_string"], "$k2":["$json_string"], ... }
        raw_hash.each do |key, array|
          if 0 < array.length 
            if is_json(array[0])
              act_json = array[0]
              act_hash = Oj.load(act_json)
              act_hash.each do |k, v|
                log_hash[k] = v

              end
            else
              log_hash[key] = array[0]
            end
          end
        end

        # simplify log datetime => logdt
        log_hash["logdt"] = nil
        if log_hash.has_key?("api_logtime")
          logdt = log_hash["api_logtime"][0..18]
          log_hash["logdt"] = logdt.gsub(/T/, " ")
        end
        
        log_hash[@key_name] = raw_json 
      end

      log_hash
    end
  end
end
