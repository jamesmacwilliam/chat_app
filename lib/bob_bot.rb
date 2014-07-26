class BobBot
  attr_accessor :data

  RESPONSES = {
    /.*\?$/ => 'Sure.',
    /^\s*$/ => 'Fine. Be that way!',
    /^[^a-z]*$/ => 'Whoa, chill out!',
    /.*/ => 'Whatever.'
  }

  NAME = 'bob'

  def initialize(data)
    @data = JSON.parse(data)
  end

  def get_response
    convert_data_for_response(get_response_text) if talking_to_bob?
  end

  def convert_data_for_response(text)
    data.merge({sender_id: data['receiver_id'], receiver_id: data['sender_id'], text: text}).to_json
  end

  def get_response_text
    RESPONSES.detect {|pattern, response| pattern.match stripped_text }.last
  end

  def talking_to_bob?
    data['receiver_id'] == NAME
  end

  def stripped_text
    data['text'].gsub(/^[@]#{NAME}/, '')
  end
end
