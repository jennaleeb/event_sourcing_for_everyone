ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "mocha/setup"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def register_account_command(email: 'some-email@mail.com')
    command = Commands::Account::Register::Command.new(
      email: email,
      is_active: true,
    )
    Commands::Account::Register::CommandHandler.new.handle(command)
  end

  def change_plan_command(account, new_plan_tier: 'paid')
    command = Commands::Account::ChangePlan::Command.new(
      new_plan_tier: new_plan_tier,
      object_reference_id: account.uuid,
    )
    Commands::Account::ChangePlan::CommandHandler.new.handle(command)
  end

  def disable_command(account, reason: 'some reason')
    command = Commands::Account::Disable::Command.new(
      is_active: false,
      reason: reason,
      object_reference_id: account.uuid,
    )
    Commands::Account::Disable::CommandHandler.new.handle(command)
  end
end
