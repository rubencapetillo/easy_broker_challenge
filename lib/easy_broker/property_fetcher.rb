# frozen_string_literal: true

require_relative "api_client"

module EasyBroker
  class PropertyFetcher
    PROPERTIES_PATH = "/v1/properties"
    DEFAULT_PAGE_SIZE = 50

    def initialize(api_client:, page_size: DEFAULT_PAGE_SIZE)
      @api_client = api_client
      @page_size = page_size
    end

    def each_property(max_pages: nil)
      return enum_for(:each_property, max_pages: max_pages) unless block_given?

      page = 1

      loop do
        data = api_client.get(PROPERTIES_PATH, params: { page: page, limit: page_size })

        properties = Array(data["content"])
        properties.each { |property| yield property }

        pagination     = data["pagination"] || {}
        has_next_page  = pagination["next_page"]

        break unless has_next_page

        page += 1
        break if max_pages && page > max_pages
      end
    end

    private

    attr_reader :api_client, :page_size
  end
end
