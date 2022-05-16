import consumer from "./consumer"

const appRoom = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const messages = document.getElementById('messages');
    messages.insertAdjacentHTML('afterbegin', data['message']);
    messages.scrollTo(0, messages.scrollHeight);
  },

  speak: function(message, post_id) {
    return this.perform('speak', {message: message, post_id: post_id});
  }
});

$(document).on("keydown", ".room_message_form_textarea",  function(e) {
  if (e.key === "Enter" && e.shiftKey === true) {
    const post_id = $('textarea').data('post_id')
    appRoom.speak(e.target.value, post_id);
    e.target.value = '';
    e.preventDefault();
  }
})
