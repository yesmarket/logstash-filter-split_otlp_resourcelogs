# encoding: utf-8
require "logstash/codecs/base"
require "logstash/json"
require "logstash/event"
require "json"
require "jsonpath"

class LogStash::Filters::SplitOtlpResourcelogs < LogStash::Filters::Base

  config_name "split_otlp_resourcelogs"

  config :remove_resourcelogs, :validate => :boolean, :default => true

  config :remove_original, :validate => :boolean, :default => false

  config :nested_data_field, :validate => :string, :default => "$..logRecords[*].body.stringValue"

  def register
  end

  def filter(event)

    # puts "received: #{event}\r\n"
    # puts "received class: #{event.class}\r\n"

    json = event.to_json
    # puts "json: #{json}\r\n"

    results = JsonPath.new(@nested_data_field).on(json)
    # puts "results: #{results}\r\n"
    # puts "results class: #{results.class}\r\n"

    return if results.empty?

    results.each do |result|

      # puts "result: #{result}\r\n"
      # puts "result class: #{result.class}\r\n"

      # some syslogs come through with some text before the json string
      refined = "[#{result.match(/\{.*\}$/)[0].gsub(/\}\{/,'},{')}]"
      # puts "refined: #{refined}\r\n"
      # puts "refined class: #{refined.class}\r\n"

      JSON.parse(refined).each do |item|

        # puts "item: #{item}\r\n"
        # puts "item class: #{item.class}\r\n"

        event_split = event.clone
        item.each do |key, value|
          # puts "key: #{key}, value: #{value}\r\n"
          event_split.set(key, value) unless key.downcase == "timestamp"
        end
        event_split.remove('resourceLogs') if @remove_resourcelogs
        event_split.remove('event') if @remove_original
        filter_matched(event_split)

        yield event_split

      end

    end

    # Cancel this event, we'll use the newly generated ones above.
    event.cancel

  end

end
