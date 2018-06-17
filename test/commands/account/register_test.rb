require 'test_helper'

class RegisterTest < ActiveSupport::TestCase
  test "raises validation errors" do
    assert_raises ArgumentError do
      command = Commands::Account::Register::Command.new(
        email: nil,
        is_active: true,
      )
    end
  end

  test "calls method on aggregate object" do
    command = Commands::Account::Register::Command.new(
      email: 'some-email@mail.com',
      is_active: true,
    )
    account = Commands::Account::Register::CommandHandler.new.handle(command)

    account = EventStore.load(Domain::AccountObject, account.uuid)

    assert_equal 'some-email@mail.com', account.email
  end
end
