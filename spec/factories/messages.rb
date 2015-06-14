FactoryGirl.define do
  factory :message do
    association :created_by, factory: :user
    association :thread, factory: :message_thread
    body "Meg: I just want to kill myself I'm gonna go upstairs and eat a whole bowl of peanuts."
  end
end
