require 'json'
require 'spec_helper'
require 'webmock/rspec'

headers = {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.2'}

describe 'Mailgun::API::Messages' do
  describe ':send' do
    it 'should make a request to mailgun' do
      stub_request(:post, 'https://api:test@api.mailgun.net/v3/pr.co/messages')
        .with(:headers => headers)
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test')
      message = Mailgun::Message.new
      res = client.messages.send(message, 'pr.co')

      expect(res.code).to eq(200)
    end

    it 'should have an h:Reply-To header when setting reply_to' do
      stub_request(:post, 'https://api:test@api.mailgun.net/v3/pr.co/messages')
        .with(:body => { "h:Reply-To" => "test@pr.co" }, :headers => headers)
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test')
      message = Mailgun::Message.new
      message.reply_to = "test@pr.co"
      res = client.messages.send(message, 'pr.co')

      expect(res.code).to eq(200)
    end

    it 'should make a request when the message contains tags' do
      stub_request(:post, 'https://api:test@api.mailgun.net/v3/pr.co/messages')
        .with(:headers => headers)
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test')
      message = Mailgun::Message.new
      message.tags = [ "Hello", "World" ]
      res = client.messages.send(message, 'pr.co')

      expect(res.code).to eq(200)
    end


    it 'should make a request when the message contains a string tag' do
      stub_request(:post, 'https://api:test@api.mailgun.net/v3/pr.co/messages')
        .with(:headers => headers)
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test')
      message = Mailgun::Message.new
      message.tags = "Omg"
      res = client.messages.send(message, 'pr.co')

      expect(res.code).to eq(200)
    end

    it 'should make a request when the message contains variables' do
      stub_request(:post, 'https://api:test@api.mailgun.net/v3/pr.co/messages')
        .with(:headers => headers)
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test')
      message = Mailgun::Message.new
      message.variables = { a: "Hello",  b: "World" }
      res = client.messages.send(message, 'pr.co')

      expect(res.code).to eq(200)
    end

    it 'should raise a Mailgun::Exception if status is not 200' do
      stub_request(:post, 'https://api:yolo@api.mailgun.net/v3/pr.co/messages')
        .with(:headers => headers)
        .to_return(body: {message: 'error', errors: ['Bad username / password']}.to_json, status: 400, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('yolo')
      message = Mailgun::Message.new

      expect {client.messages.send(message, 'pr.co')}.to raise_error(Mailgun::Exception)
    end


    it 'should return a payload with variables set' do
      text = "Hello World. Omg awesome"
      message = Mailgun::Message.new(text: text)
      expect(message.to_h['text']).to eq(text)
    end
  end
end
