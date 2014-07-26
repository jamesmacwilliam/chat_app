class chat.ChatsIndexView extends Backbone.View
  template: ich.chats_index

  el: '#chat_window'

  events: =>
    'submit #input-form, #pm-input-form': 'send_message'
    'click #members a': 'select_member'
    'click a[data-target=member]': 'handle_room_member_click'

  initialize: =>
    $('body').on 'message', @message_handler
    @collection.on 'add', (model) => @add_member(model.id)
    @current_room = 'main'
    @default_rooms = ['main']
    @rooms = []

  render: =>
    @$el.html @template()
    @setup_members()
    @setup_rooms()

  setup_members: =>
    _.each @collection.models, (model) => @add_member(model.id)

  setup_rooms: =>
    _.each @default_rooms, @add_room

  add_room: (room) =>
    unless _.include @rooms, room
      @add_member(room, '#rooms')
      @rooms.push room

  add_member: (member_id, selector = '#members') =>
    @$(selector).append(@generate_panel(@generate_link('member', member_id))) unless member_id == @model.id

  generate_link: (type, id, text = null) =>
    $('<a>', text: (text || id), 'data-target': type, 'data-id': id)

  handle_room_member_click: (e) ->
    @open_room($(e.currentTarget).data('id'))

  open_room: (room_id) ->
    @add_room(room_id)
    @collection.get(room_id)
    if room_id == 'main'
      @$('.chat-well').removeClass('hide')
      @$('.pm-well').addClass('hide')
      @$('#pms').html('')
      delete @receiver_id
      @current_room = 'main'
    else
      @$('.chat-well').addClass('hide')
      @$('.pm-well').removeClass('hide')
      @update_pm(room_id) unless @current_room == room_id
      @receiver_id = room_id
      @current_room = room_id

  update_pm: (user_id) =>
    room = @$('#pms')
    room.html('')
    chat_history = @collection.get(user_id).get('chat_history')
    unless _.isEmpty(chat_history)
      _.each chat_history, (chat) =>
        room.append(@generate_panel(chat.text, chat.sender_id))


  send_message: (e) =>
    e.preventDefault()
    @model.send_chat(@get_chat_text(e), @receiver_id, @current_room != 'main')

  get_chat_text: (e) =>
    input = $(e.currentTarget).find('input')
    text = input.val()
    input.val('')
    text

  generate_panel: (body, header = null) =>
    panel = $('<div>', {class: 'panel panel-default'})
    panel.append($('<div>', {class: 'panel-heading', text: header})) if header
    panel.append($('<div>', {class: 'panel-body', html: body}))
    panel

  add_message_to_chat: (selector, text, sender) =>
    @$(selector).append(@generate_panel(text, sender))
    @collection.get(@current_room).add_message_to_chat_history(text, sender) unless @current_room == 'main'
    @$el.stop().animate({
      scrollTop: $('#chat-text')[0].scrollHeight
    }, 800)

  message_handler: (body, data) =>
    @collection.add_user(data.sender_id)
    if data.pm == 'true'
      if @model.id == data.receiver_id
        @open_room(data.sender_id)
        @add_message_to_chat('#pms', data.text, data.sender_id)
      else if @model.id == data.sender_id
        @open_room(data.receiver_id)
        @add_message_to_chat('#pms', data.text, data.sender_id)
    else
      @open_room('main')
      @add_message_to_chat('#chat-text', data.text, data.sender_id)
