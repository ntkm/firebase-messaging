module Firebase
  module Messaging
    class Request
      class For
        TOPIC_REGEX = /\A\/topics\/(.+)\Z/

        attr_reader :to, :topics, :registration_ids

        def initialize(directions)
          if directions.is_a? String
            @to = directions
          elsif directions.is_a? Array
            if directions.flatten.any? { |direction| TOPIC_REGEX === direction }
              if directions.flatten.size == 1
                @to = directions.first
              else
                @topics = directions
              end
            else
              @registration_ids = directions
            end
          end
        end

        def payload
          return { to: @to } if @to
          return { registration_ids: @registration_ids } if @registration_ids

          conditions = @topics.inject([]) do |arr, topic|
            if topic.is_a? Array
              arr.push "(#{or_condition(topic)})"
            else
              arr.push topic_condition(topic)
            end
          end

          { condition: conditions.join(' && ') }
        end

        def type
          if (@to && !(TOPIC_REGEX === @to)) || @registration_ids
            :down_stream_http_message
          else
            :topic_message
          end
        end

        private

        def or_condition(or_topics)
          or_topics.select { |topic| TOPIC_REGEX === topic }
                   .map { |topic| topic_condition(topic) }
                   .join(' || ')
        end

        def topic_condition(topic)
          topic.gsub(TOPIC_REGEX, '\'\1\' in topics')
        end
      end
    end
  end
end
