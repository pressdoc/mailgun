require 'json'
require 'spec_helper'
require 'webmock/rspec'

describe 'Mailgun::Client' do
  let(:client) { Mailgun::Client.new(APIKEY) }

  it 'should accept an api_key' do
    expect(client).to be_an_instance_of(Mailgun::Client)
  end

  it 'should default to the US api_host' do
    expect(client.api_host).to be == 'api.mailgun.net'
  end

  it 'should accept an API region' do
    expect(Mailgun::Client.new(APIKEY, 'EU')).to be_an_instance_of(Mailgun::Client)
  end

  it 'should correctly set the API region for the EU region' do
    expect(Mailgun::Client.new(APIKEY, 'EU').api_host).to be == 'api.eu.mailgun.net'
  end

  it 'should set the correct URL for the EU region' do
    expect(Mailgun::Client.new(APIKEY, 'EU').url).to be == "https://api:#{APIKEY}@api.eu.mailgun.net/v3/"
  end

  it 'should have a domains api' do
    expect(client.domains).to be_an_instance_of(Mailgun::API::Domains)
  end

  it 'should have a messages api' do
    expect(client.messages).to be_an_instance_of(Mailgun::API::Messages)
  end
end
