# frozen_string_literal: true

require_relative "property_fetcher"

module EasyBroker
  class PropertyTitlePrinter
    def initialize(property_fetcher:, io: $stdout)
      @property_fetcher = property_fetcher
      @io = io
    end

    def call
      property_fetcher.each_property do |property|
        title = property["title"]
        io.puts(title) if title
      end
    end

    private

    attr_reader :property_fetcher, :io
  end
end
