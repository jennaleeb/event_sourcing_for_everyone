class SubscriberManager
  def self.notify_subscribers(event, is_new_event)
    ALL_SUBSCRIBERS.each do |subscriber|
      subscriber.new.process(event, is_new_event)
    end
  end

  ALL_SUBSCRIBERS = [
    Projectors::AllAccounts,
    Projectors::ActiveAccounts
  ]
end
