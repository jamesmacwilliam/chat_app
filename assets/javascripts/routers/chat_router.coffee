class chat.ChatsRouter extends Backbone.Router

  routes:
    '':     'index'
    ':id':  'private_message'

  index: =>
    new chat.ChatsIndexView(el: '#chat_window', collection: chat.collection, model: chat.collection.where(current: true)[0]).render()

  private_message: (id) =>
