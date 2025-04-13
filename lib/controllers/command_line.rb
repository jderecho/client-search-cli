# frozen_string_literal: true

module Controllers
  class CommandLine < Thor
    DEFAULT_CLIENT_JSON_PATH = File.expand_path('../../lib/data/clients.json', __dir__)
    DEFAULT_FILE_OPTIONS = {
      aliases: '-f', default: DEFAULT_CLIENT_JSON_PATH, desc: 'Url or path to the file'
    }.freeze

    desc 'search FIELD SEARCH_TERM', 'search for a client by FIELD and SEARCH_TERM'
    method_option :file, **DEFAULT_FILE_OPTIONS
    def search(field, search_term)
      render Commands::Search.perform(@clients, field, search_term)
    end

    desc 'find_duplicates FIELD', 'find duplicates by FIELD'
    method_option :file, **DEFAULT_FILE_OPTIONS
    def find_duplicates(field)
      render Commands::FindDuplicates.perform(@clients, field)
    end

    no_commands do
      def invoke_command(command, *args)
        load_json_file
        super
      rescue StandardError => e
        handle_exception(e)
      end
    end

    private

    def render(result)
      puts result.empty? ? 'No results found' : result
    end

    def load_json_file
      return unless options[:file]

      @clients = Services::LoadJson.new(options[:file]).perform
    end

    def handle_exception(e)
      puts e.message
    end
  end
end
