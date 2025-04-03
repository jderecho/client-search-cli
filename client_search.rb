require 'json'

class ClientSearch
  def initialize(json_file)
    @clients = JSON.parse(File.read(json_file), symbolize_names: true)
  end

  def search_by_field(field, query)
    @clients.select { |client| client[field.to_sym].to_s.downcase.include?(query.downcase) }
  end

  def find_duplicates(field)
    email_counts = Hash.new { |hash, key| hash[key] = [] }
    @clients.each { |client| email_counts[client[field.to_sym]] << client }
    email_counts.select { |email, clients| clients.size > 1 }
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Usage: ruby client_search.rb <json_file> [search <field> <query> | duplicates <field>]"
    exit 1
  end

  json_file = ARGV[0]
  clients = ClientSearch.new(json_file)

  case ARGV[1]
  when 'search'
    if ARGV[2].nil? || ARGV[3].nil?
      puts "Please provide a field and a search query."
      exit 1
    end
    results = clients.search_by_field(ARGV[2], ARGV[3])
    puts results.empty? ? "No matches found." : results
  when 'duplicates'
    if ARGV[2].nil?
      puts "Please provide a field to check for duplicates."
      exit 1
    end
    duplicates = clients.find_duplicates(ARGV[2])
    puts duplicates.empty? ? "No duplicate values found." : duplicates
  else
    puts "Invalid command. Use 'search <field> <query>' or 'duplicates <field>'."
  end
end
