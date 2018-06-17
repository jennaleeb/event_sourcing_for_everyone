require 'test_helper'

class EventStoreTest < ActiveSupport::TestCase
  def setup
    EventStore.event_streams = {} # "resetting db"
  end

  test 'event stream is empty if no events' do
    account = Account.new
    assert_equal ({}), EventStore.event_streams
  end

  test 'stores events in event stream' do
    account = Account.new
    account.register(email: 'some-email@mail.com')
    assert_equal 1, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'some-email@mail.com'
    }), EventStore.event_streams[account.uuid].first.payload

    account = EventStore.load(Account, account.uuid)
    account.disable(reason: 'some reason')

    assert_equal 2, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: false,
      reason: 'some reason'
    }), EventStore.event_streams[account.uuid].last.payload
  end

  test 'different objects different event streams' do
    account = Account.new
    account.register(email: 'some-email@mail.com')
    assert_equal 1, EventStore.event_streams[account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'some-email@mail.com'
    }), EventStore.event_streams[account.uuid].first.payload

    another_account = Account.new
    another_account.register(email: 'another_email@mail.com')
    assert_equal 1, EventStore.event_streams[another_account.uuid].length
    assert_equal ({
      is_active: true,
      email: 'another_email@mail.com'
    }), EventStore.event_streams[another_account.uuid].first.payload
  end

  test 'load recreates from events' do
    account = Account.new
    account.register(email: 'some-email@mail.com')
    account.change_plan(new_plan_tier: 'paid')
    account.disable(reason: 'some reason')

    account = EventStore.load(Account, account.uuid)

    refute account.is_active
    assert_equal 'paid', account.plan_tier
  end

  test 'load works even if no events' do
    account = Account.new
    account = EventStore.load(Account, account.uuid)

    refute account.is_active
  end
end
