require 'json'
require 'spec_helper'
require 'webmock/rspec'

describe 'Mailgun::Client' do
  it 'should accept a api_key and domain' do
    expect(Mailgun::Client.new('test', 'pr.co')).to be_an_instance_of(Mailgun::Client)
  end

  describe ':send_message' do
    it 'should make a request to mailgun' do
      stub_request(:post, "https://api:test@api.mailgun.net/v3/pr.co/messages").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.2'}).
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      # stub_request(:any, 'https://api:test@api.mailgun.net/v3/pr.co/messages"')
      #   .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('test', 'pr.co')
      message = Mailgun::Message.new
      res = client.send_message(message)

      puts "RESPONSE #{res}"

      expect(res.code).to eq(200)
    end

    it 'should have an auth header when using an api key' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('abc123', 'pr.co')
      message = Mailgun::Message.new

      client.send_message(message)

      expect(WebMock).to have_requested(:post, 'https://api.sendgrid.com/api/mail.send.json')
        .with(headers: {'Authorization' => 'Bearer abc123'})
    end

    # it 'should have a username + password when using them' do
    #   stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
    #     .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

    #   client = Mailgun::Client.new('abc123', 'pr.co')
    #   mail = Mailgun::Message.new

    #   res = client.send_message(mail)

    #   expect(WebMock).to have_requested(:post, 'https://api.sendgrid.com/api/mail.send.json')
    #     .with(body: 'api_key=abc123&api_user=foobar')
    # end

    it 'should raise a Mailgun::Exception if status is not 200' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'error', errors: ['Bad username / password']}.to_json, status: 400, headers: {'X-TEST' => 'yes'})

      client = Mailgun::Client.new('abc123', 'pr.co')
      mail = Mailgun::Message.new

      expect {client.send_message(mail)}.to raise_error(Mailgun::Exception)
    end
  end
end
