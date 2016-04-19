require 'spec_helper'
require 'webmock/rspec'

vcr_opts = { :cassette_name => "domains" }

describe 'Mailgun::API::Domains', vcr: vcr_opts do
  let(:client) { Mailgun::Client.new(APIKEY) }
  let(:domain) { "yolo-test.domain" }

  it 'should return a list of domains' do
    result = client.domains.all
    expect(result.body['items'].size).to be > 0
  end

  it 'should return the domain.' do
    result = client.domains.get(domain)
    expect(result.body).to include("domain")
    expect(result.body["domain"]["name"]).to eq(domain)
  end

  it 'should a domain' do
    result = client.domains.create(domain, { smtp_password: 'super_secret', spam_action: 'tag' })
    expect(result.body['domain']["name"]).to eq(domain)
    expect(result.body['domain']["spam_action"]).to eq("tag")
    expect(result.body['domain']["smtp_password"]).to eq("super_secret")
  end

  it 'should delete a domain' do
    result = client.domains.delete(domain)
    expect(result).to be_truthy
  end
end
