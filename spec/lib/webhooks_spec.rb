require 'spec_helper'
require 'webmock/rspec'

vcr_opts = { :cassette_name => "webhooks" }

describe 'Mailgun::API::Webhooks', vcr: vcr_opts do
  let(:client) { Mailgun::Client.new(APIKEY) }
  let(:domain) { TESTDOMAIN }
  let(:testhook) { 'bounce' }
  let(:testhookup) { 'bounceup' }

  it 'creates a webhook' do

    puts TESTDOMAIN

    result = client.webhooks.add(domain, 'bounce', "http://example.com/mailgun/events/#{testhook}")
    expect(result.body["message"]).to eq("Webhook has been created")
    expect(result.body["webhook"]["url"]).to eq("http://example.com/mailgun/events/#{testhook}")
  end

  it 'gets a webhook.' do
    result = client.webhooks.get(domain, testhook)
    expect(result.body["webhook"]["url"]).to eq("http://example.com/mailgun/events/#{testhook}")
  end

  it 'gets a list of all webhooks.' do
    result = client.webhooks.all(domain)
    expect(result.body["webhooks"]["bounce"]["url"]).to eq("http://example.com/mailgun/events/#{testhook}")
  end

  it 'updates a webhook.' do
    result = client.webhooks.update(domain, testhook, 'bounce', "http://example.com/mailgun/events/#{testhookup}")
    expect(result.body["message"]).to eq("Webhook has been updated")
    expect(result.body["webhook"]["url"]).to eq("http://example.com/mailgun/events/#{testhookup}")
  end

  it 'removes a webhook' do
    result = client.webhooks.remove(domain, testhook)
    expect(result.body['message']).to eq("Webhook has been deleted")
    expect(result.body['webhook']['url']).to eq("http://example.com/mailgun/events/#{testhookup}")
  end

end
