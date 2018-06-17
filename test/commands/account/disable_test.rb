require 'test_helper'

class DisableTest < ActiveSupport::TestCase
  def setup
    @account = EventStore.load(Domain::AccountObject)
  end

  test "raises validation errors if plan_tier is missing" do
    assert_raises ArgumentError do
      command = Commands::Account::Disable::Command.new(
        reason: nil,
        object_reference_id: @account.uuid
      )
    end
  end

  test "calls method on aggregate object" do
    command = Commands::Account::Disable::Command.new(
      reason: 'some reason',
      object_reference_id: @account.uuid,
    )
    Commands::Account::Disable::CommandHandler.new.handle(command)

    account = EventStore.load(Domain::AccountObject, @account.uuid)

    refute account.is_active
  end
end
