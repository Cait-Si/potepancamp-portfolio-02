class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    new_message = Message.create!(content: data['message'], user_id: current_user.id, post_id: data['post_id'])
    ActionCable.server.broadcast 'room_channel', {message: render_message(new_message)}
  end

  private


  def render_message(message)
    ApplicationController.renderer.render(partial: 'shared/message', locals: { message: message, current_user: current_user })
  end
end
