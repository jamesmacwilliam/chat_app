class chat.User extends Backbone.Model

  send_chat: (text, receiver_id = null, pm = null) =>
    receiver_id ||= @get_user_id_from_text(text)
    chat.ws.send JSON.stringify(
      receiver_id: receiver_id
      sender_id: @id
      text: text
      pm: pm
    )

  get_user_id_from_text: (text) =>
    match = text.match /^@(\S*)/
    match[1] if match

  add_message_to_chat_history: (text, sender) =>
    chat_history = @get('chat_history') || []
    chat_history.push(sender_id: sender, text: text)
    @set(chat_history: chat_history)
