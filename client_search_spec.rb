require 'rspec'
require_relative 'client_search'

RSpec.describe ClientSearch do
  let(:json_file) { 'test_clients.json' }
  let(:data) do
    [
      { id: 1, full_name: 'John Doe', email: 'john.doe@gmail.com' },
      { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' },
      { id: 3, full_name: 'Alex Johnson', email: 'alex.johnson@hotmail.com' },
      { id: 4, full_name: 'Test Jane Smith', email: 'jane.smith@yahoo.com' }
    ]
  end

  before do
    File.write(json_file, JSON.dump(data))
  end

  after do
    File.delete(json_file) if File.exist?(json_file)
  end

  subject { described_class.new(json_file) }

  describe '#search_by_field' do
    it 'finds clients by partial name match' do
      expect(subject.search_by_field('full_name', 'Jane')).to contain_exactly(
        { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' },
        { id: 4, full_name: 'Test Jane Smith', email: 'jane.smith@yahoo.com' }
      )
    end

    it 'returns an empty array if no matches are found' do
      expect(subject.search_by_field('full_name', 'Nonexistent')).to eq([])
    end
  end

  describe '#find_duplicates' do
    let(:field) { 'email' }

    it 'finds duplicate emails' do
      expect(subject.find_duplicates(field)).to eq({ 'jane.smith@yahoo.com' => [
        { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' },
        { id: 4, full_name: 'Test Jane Smith', email: 'jane.smith@yahoo.com' }
      ] })
    end

    it 'returns an empty hash if no duplicates are found' do
      File.write(json_file, JSON.dump([{ id: 1, full_name: 'John Doe', email: 'john.doe@gmail.com' }]))
      expect(subject.find_duplicates(field)).to eq({})
    end
  end
end