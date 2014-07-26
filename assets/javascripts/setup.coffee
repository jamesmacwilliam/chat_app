window.chat = {}

protocol = if location.hostname == 'localhost' then "ws://" else "wss://"

url = "#{protocol}#{location.host}/"

chat.ws = new WebSocket(url)

chat.ws.onmessage = (message) ->
  data = JSON.parse(message.data)
  $('body').trigger('message', data)
