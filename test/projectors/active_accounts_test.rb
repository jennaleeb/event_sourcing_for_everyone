require 'test_helper'

class ActiveAccountsTest < ActiveSupport::TestCase
  def setup
    # reset in-memory dbs
    Projectors::ActiveAccounts.active_accounts_count_report[:active] = 0
    EventStore.event_streams = {}
  end

  test "active_accounts projector adds to active" do
    register_account_command
    register_account_command


    assert_equal 2, Projectors::ActiveAccounts.active_accounts_count_report[:active]
  end

  test "active_accounts does not get incremented when objects are rebuilt" do
    account = register_account_command

    assert_equal 1, Projectors::ActiveAccounts.active_accounts_count_report[:active]

    account = EventStore.load(Domain::AccountObject, account.uuid)

    assert_equal 1, Projectors::ActiveAccounts.active_accounts_count_report[:active]
  end
end