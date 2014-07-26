require './app'
require './middlewares/chat'

use Chat::Backend

run Chat::App
