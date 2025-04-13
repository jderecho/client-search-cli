# frozen_string_literal: true

module Services
  # This class is responsible for finding duplicate clients in an array of clients based on a specified field.
  class FindDuplicate
    # @param records [Array<Hash>] The array of clients to check for duplicates.
    # @param field [String] The field to check for duplicates (e.g., 'email', 'full_name').
    def initialize(records, field)
      @clients = records
      @field = field
    end

    # @return [Array<Hash>]
    def perform
      validate_field!
      find_duplicates
    end

    private

    attr_reader :json_file, :field, :clients

    # @return [Void]
    # @raise [ArgumentError] if the field is not valid
    def validate_field!
      raise ArgumentError, 'Field cannot be nil' if field.nil?
      raise ArgumentError, "Invalid field: #{field}" unless Models::Client::VALID_FIELDS.include?(field)
    end

    # @return [Array<Hash>]
    def duplicates_by_field(field)
      clients_by_field = @clients.group_by { |client| client[field.to_sym] }
      clients_by_field.select { |_field, clients| clients.size > 1 }
    end

    # @return [Array<Hash>]
    def find_duplicates
      duplicates_by_field(field)
    end
  end
end
