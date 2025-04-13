# frozen_string_literal: true

module Services
  # This class is responsible for searching for clients in an Array based on a specified field.
  class Search
    # @param clients [Array<Hash>] The array of clients to search.
    # @param field [String] The field to search for (e.g., 'email', 'full_name').
    # @param search_term [String] The term to search for in the specified field.
    def initialize(clients, field, search_term)
      @clients = clients
      @field = field
      @search_term = search_term
    end

    def perform
      validate_fields!
      search_clients
    end

    private

    attr_reader :json_file, :field, :search_term, :clients

    # @return [Void]
    # @raise [ArgumentError] if the field is not valid
    def validate_fields!
      raise ArgumentError, "Invalid field: #{field}" unless Models::Client::VALID_FIELDS.include?(field)
      raise ArgumentError, 'Search term cannot be nil' if search_term.nil?
      raise ArgumentError, 'Search term cannot be an empty string' if search_term == ''
    end

    # @return [Array<Hash>]
    def search_clients
      @clients.select do |client|
        value = client[field.to_sym]

        if value.is_a?(String)
          # if the field is a string, perform a partial match
          value.to_s.downcase.include?(search_term.to_s.downcase)
        elsif value.is_a?(Integer)
          # if the field is an integer, perform an exact match
          value == search_term.to_i
        end
      end
    end
  end
end
