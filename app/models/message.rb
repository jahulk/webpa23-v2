class Message < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  after_create_commit do
    broadcast_prepend_to "messages_index", partial: "messages/message", target: "messages"
  end
end
