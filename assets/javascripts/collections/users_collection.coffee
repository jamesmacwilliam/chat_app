class chat.UsersCollection extends Backbone.Collection

  model: chat.User

  add_user: (user_id) =>
    @add(id: user_id) unless @get(user_id)
