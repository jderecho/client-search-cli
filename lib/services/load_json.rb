# frozen_string_literal: true

module Services
  class LoadJson
    # This class is responsible for loading a JSON file and parsing it into a Ruby hash.
    # It checks for the existence of the file and ensures that it is a valid JSON file.
    # @param file_path [String] The path to the JSON file.
    def initialize(file_path)
      @file_path = file_path
    end

    def perform
      validate_file!
      load_json
    end

    private

    attr_reader :file_path

    # @return [Void]
    # @raise [ArgumentError] if the file does not exist or is not a valid JSON file
    def validate_file!
      raise ArgumentError, "File does not exist: #{@file_path}" unless File.exist?(@file_path)
      raise ArgumentError, "File is not a valid JSON file: #{@file_path}" unless File.extname(@file_path) == '.json'
    end

    # @return [Hash]
    # @raise [ArgumentError] if the JSON file cannot be parsed
    def load_json
      file = File.read(@file_path)
      JSON.parse(file, symbolize_names: true)
    rescue JSON::ParserError => e
      raise ArgumentError, "Failed to parse JSON file: #{@file_path}. Error: #{e.message}"
    end
  end
end
