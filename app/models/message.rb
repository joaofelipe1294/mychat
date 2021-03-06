class Message < ApplicationRecord
  belongs_to :group
  belongs_to :user
  validates_presence_of :body
  after_create :broadcast_message

  private

    def broadcast_message
      ActionCable.server.broadcast("chat_channel", {
        user: self.user,
        body: self.body,
        user_id: self.user_id
      })
    end

end
