module Reactors
  class DisabledAccountEmailSender
    def process(event, is_new_event)
      return unless is_new_event
      if event.payload[:reason] == Domain::AccountObject::DISABLED_REASONS[:manually_disabled]
        SendSorryToSeeYouGoEmailJob.perform_later(event.object_reference_id)
      end
    end
  end
end
