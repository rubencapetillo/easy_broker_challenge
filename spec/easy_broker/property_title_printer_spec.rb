# frozen_string_literal: true

require "stringio"
require_relative "../../lib/easy_broker/property_title_printer"

RSpec.describe EasyBroker::PropertyTitlePrinter do
  let(:io) { StringIO.new }

  class FakePropertyFetcher
    def initialize(properties)
      @properties = properties
    end

    def each_property(&block)
      @properties.each(&block)
    end
  end

  it "prints the title of each property to the given IO" do
    properties = [
      { "title" => "Casa en Condesa" },
      { "title" => "Departamento en Polanco" },
      { "title" => "Loft sin título" },
      { "title" => nil },
      {}
    ]

    fetcher = FakePropertyFetcher.new(properties)
    printer = described_class.new(property_fetcher: fetcher, io: io)

    printer.call

    io.rewind
    output = io.read

    expect(output).to include("Casa en Condesa")
    expect(output).to include("Departamento en Polanco")
    expect(output).to include("Loft sin título")
  end
end
