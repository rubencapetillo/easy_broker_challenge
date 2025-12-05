# frozen_string_literal: true

require_relative "../../lib/easy_broker/property_fetcher"

RSpec.describe EasyBroker::PropertyFetcher do
  class FakeApiClient
    attr_reader :calls, :received_params

    def initialize(responses)
      @responses = responses
      @calls = 0
      @received_params = []
    end

    def get(path, params:)
      @calls += 1
      @received_params << { path: path, params: params }
      @responses[@calls - 1] || {}
    end
  end

  it "iterates over all properties across pages and stops when there is no next_page" do
    responses = [
      {
        "content" => [
          { "title" => "Propiedad página 1 - A" },
          { "title" => "Propiedad página 1 - B" }
        ],
        "pagination" => { "next_page" => "https://api.stagingeb.com/v1/properties?page=2" }
      },
      {
        "content" => [
          { "title" => "Propiedad página 2 - A" }
        ],
        "pagination" => { "next_page" => nil }
      }
    ]

    fake_client = FakeApiClient.new(responses)
    fetcher = described_class.new(api_client: fake_client, page_size: 50)

    collected = []
    fetcher.each_property { |property| collected << property }

    expect(collected.size).to eq(3)
    expect(collected.map { |p| p["title"] }).to contain_exactly(
      "Propiedad página 1 - A",
      "Propiedad página 1 - B",
      "Propiedad página 2 - A"
    )

    expect(fake_client.calls).to eq(2)

    expect(fake_client.received_params[0][:params][:page]).to eq(1)
    expect(fake_client.received_params[1][:params][:page]).to eq(2)
  end
end
