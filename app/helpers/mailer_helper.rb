# frozen_string_literal: true

module MailerHelper
  def self.included(base)
    base.class_eval do
      include ActionMailer::Html2Text
    end
  end

  # Our domain name
  def domain
    @domain ||= SiteConfig.first.email_domain
  end

  # Deprecated
  def thread_address(thread)
    "<thread-#{thread.public_token}@#{domain}>"
  end

  # Message-specific email address
  # No name in the address to stop it being added to automatic client address books
  def message_address(message)
    "<message-#{message.public_token}@#{domain}>"
  end

  def message_chain(message, thread)
    return thread_address(thread) if !message || message.id == message.in_reply_to.try(:id)
    "#{message_chain(message.in_reply_to, thread)} #{message_address(message)}".strip
  end

  # Notifications are sent from a fixed email but with different names
  def user_notification_address(user)
    ['"', user.name, '" <notifications@', domain, '>'].join
  end

  def no_reply_address
    "No reply <no-reply@#{domain}>"
  end
end
