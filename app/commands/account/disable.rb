module Commands
  module Account
    module Disable
      class Command < BaseCommand
        attr_reader :args
        def validate!
          raise ArgumentError, 'object_reference_id is missing' if args[:object_reference_id].nil?
          raise ArgumentError, 'reason is missing' if args[:reason].nil?
        end
      end

      class CommandHandler
        def handle(command)
          account = EventStore.load(Domain::AccountObject, command.args[:object_reference_id])
          account.apply(
            Events::Account::Disabled.new(
              object_reference_id: account.uuid,
              payload: {
                is_active: command.args[:is_active],
                reason: command.args[:reason]
              }
            )
          )
          account
        end
      end
    end
  end
end

