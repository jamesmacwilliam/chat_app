require 'spec_helper'
require_relative '../../lib/bob_bot'

describe BobBot do
  let(:data) { {sender_id: 'foo', receiver_id: receiver, text: text}.to_json }
  let(:receiver) { 'bob' }
  let(:text) { '  ' }
  let(:response) { JSON.parse(raw_response) }
  let(:raw_response) { BobBot.new(data).get_response }

  context 'when questioned' do
    let(:text) { 'Hello?' }

    it { expect(response['text']).to eq 'Sure.' }
  end

  context 'when shouted at' do
    let(:text) { 'HEY' }

    it { expect(response['text']).to eq 'Whoa, chill out!' }
  end

  context 'when given silence' do
    let(:text) { '  ' }

    it { expect(response['text']).to eq 'Fine. Be that way!' }
  end

  context 'when spoken to' do
    let(:text) { 'foo' }

    it { expect(response['text']).to eq 'Whatever.' }
  end

  context 'when bob is not the recipient' do
    let(:receiver) { 'bar' }

    it { expect(raw_response).to be_nil }
  end
end
