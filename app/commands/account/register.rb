module Commands
  module Account
    module Register
      class Command < BaseCommand
        attr_reader :args
        def validate!
          raise ArgumentError, 'email is missing' if args[:email].nil?
        end
      end

      class CommandHandler
        def handle(command)
          account = EventStore.load(Domain::AccountObject)
          account.apply(
            Events::Account::Registered.new(
              object_reference_id: account.uuid,
              payload: {
                is_active: command.args[:is_active],
                email: command.args[:email]
              }
            )
          )
          account
        end
      end
    end
  end
end

