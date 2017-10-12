module Firebase
  module Messaging
    class Request
      class Body
        attr_reader :notification
        attr_accessor :data

        def initialize
          @notification = Notification.new # NOTE: title, body, badge, icon
          @data = {} # NOTE: custom data for app
        end

        def notification=(title: nil, body: nil, badge: nil, icon: nil)
          @notification.title = title unless title.nil?
          @notification.body = body unless body.nil?
          @notification.badge = badge unless badge.nil?
          @notification.icon = icon unless icon.nil?
        end

        def payload
          message_payload = {}
          message_payload[:notification] = @notification.payload unless @notification.payload.empty?
          message_payload[:data] = @data unless @data.empty?
          message_payload
        end

        class Notification
          attr_accessor :title, :body, :badge, :icon

          def payload
            instance_variables.select { |key| !instance_variable_get(key).nil? }.each_with_object({}) do |key, payload|
              payload[key.to_s.delete('@').to_sym] = instance_variable_get(key)
            end
          end
        end
      end
    end
  end
end
