require 'test_helper'

class ChangePlanTest < ActiveSupport::TestCase
  def setup
    @account = EventStore.load(Domain::AccountObject)
  end

  test "raises validation errors if plan_tier is missing" do
    assert_raises ArgumentError do
      command = Commands::Account::ChangePlan::Command.new(
        new_plan_tier: nil,
        object_reference_id: @account.uuid
      )
    end
  end

  test "raises validation errors if plan_tier is not one of accepted values" do
    assert_raises ArgumentError do
      command = Commands::Account::ChangePlan::Command.new(
        new_plan_tier: 'foo',
        object_reference_id: @account.uuid
      )
    end
  end

  test "raises validation errors if plan_tier if aggregate id is missing" do
    assert_raises ArgumentError do
      command = Commands::Account::ChangePlan::Command.new(
        new_plan_tier: 'free',
        object_reference_id: nil
      )
    end
  end

  test "calls method on aggregate object" do
    command = Commands::Account::ChangePlan::Command.new(
      new_plan_tier: 'paid',
      object_reference_id: @account.uuid,
    )
    Commands::Account::ChangePlan::CommandHandler.new.handle(command)

    account = EventStore.load(Domain::AccountObject, @account.uuid)

    assert_equal 'paid', account.plan_tier
  end
end
