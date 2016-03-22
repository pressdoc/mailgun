require 'json'
require 'spec_helper'
require 'webmock/rspec'

describe 'SendGrid::Client' do
  it 'should accept a username and password' do
    expect(SendGrid::Client.new(api_user: 'test', api_key: 'test')).to be_an_instance_of(SendGrid::Client)
  end

  it 'should accept an api key' do
    expect(SendGrid::Client.new(api_key: 'sendgrid_123')).to be_an_instance_of(SendGrid::Client)
  end

  it 'accepts a block' do
    expect { |b| SendGrid::Client.new(&b) }.to yield_control
  end

  describe ':send' do
    it 'should make a request to sendgrid' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = SendGrid::Client.new(api_key: 'abc123')
      mail = SendGrid::Mail.new
      res = client.send(mail)
      expect(res.code).to eq(200)
    end

    it 'should have an auth header when using an api key' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = SendGrid::Client.new(api_key: 'abc123')
      mail = SendGrid::Mail.new

      client.send(mail)

      expect(WebMock).to have_requested(:post, 'https://api.sendgrid.com/api/mail.send.json')
        .with(headers: {'Authorization' => 'Bearer abc123'})
    end

    it 'should have a username + password when using them' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'success'}.to_json, status: 200, headers: {'X-TEST' => 'yes'})

      client = SendGrid::Client.new(api_user: 'foobar', api_key: 'abc123')
      mail = SendGrid::Mail.new

      res = client.send(mail)

      expect(WebMock).to have_requested(:post, 'https://api.sendgrid.com/api/mail.send.json')
        .with(body: 'api_key=abc123&api_user=foobar')
    end

    it 'should raise a SendGrid::Exception if status is not 200' do
      stub_request(:any, 'https://api.sendgrid.com/api/mail.send.json')
        .to_return(body: {message: 'error', errors: ['Bad username / password']}.to_json, status: 400, headers: {'X-TEST' => 'yes'})

      client = SendGrid::Client.new(api_user: 'foobar', api_key: 'abc123')
      mail = SendGrid::Mail.new

      expect {client.send(mail)}.to raise_error(SendGrid::Exception)
    end
  end
end
