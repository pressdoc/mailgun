require 'json'
require 'spec_helper'
require 'webmock/rspec'

describe 'Mailgun::Client' do
  let(:client) { Mailgun::Client.new(APIKEY) }
  let(:client_with_host) { Mailgun::Client.new(APIKEY, 'api.mailgun.net') }

  it 'should accept an api_key' do
    expect(client).to be_an_instance_of(Mailgun::Client)
  end

  it 'should accept an api_host' do
    expect(client_with_host).to be_an_instance_of(Mailgun::Client)
  end

  it 'should have a domains api' do
    expect(client.domains).to be_an_instance_of(Mailgun::API::Domains)
  end

  it 'should have a messages api' do
    expect(client.messages).to be_an_instance_of(Mailgun::API::Messages)
  end
end
