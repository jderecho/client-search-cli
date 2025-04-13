# frozen_string_literal: true

require_relative '../spec_helper'

describe Services::Search do
  subject { described_class.new(clients, field, search_term) }
  let(:clients) { JSON.parse(load_json_fixture(json_file).to_json, symbolize_names: true) }
  let(:json_file) { 'spec/fixtures/data/test_clients.json' }
  let(:field) { 'email' }
  let(:search_term) { 'john.doe@gmail.com' }

  describe 'search_term validation' do
    context 'when search_term is valid' do
      it 'does not raise an error' do
        expect { subject.perform }.not_to raise_error
      end
    end

    context 'when search_term is string' do
      it 'does not raise an error' do
        expect { subject.perform }.not_to raise_error
      end

      it 'returns clients matching the search term' do
        result = subject.perform
        expect(result).to be_a(Array)
        expect(result).not_to be_empty
        expect(result.all? { |client| client[field.to_sym].include?(search_term) }).to be_truthy
      end
    end

    context 'when search_term could be a number' do
      let(:field) { 'id' }
      let(:search_term) { 1 }

      it 'does not raise an error' do
        expect { subject.perform }.not_to raise_error
      end

      it 'returns clients matching the exact search term' do
        result = subject.perform
        expect(result).to be_a(Array)
        expect(result).not_to be_empty
        expect(result.first[field.to_sym]).to eq(search_term)
      end
    end

    context 'when search_term is nil' do
      let(:search_term) { nil }

      it 'raises an error' do
        expect { subject.perform }.to raise_error(ArgumentError, 'Search term cannot be nil')
      end
    end

    context 'when search_term is partial' do
      let(:search_term) { 'john' }

      it 'returns clients matching the partial search term' do
        result = subject.perform
        expect(result).to be_a(Array)
        expect(result).not_to be_empty
        expect(result.all? { |client| client[field.to_sym].include?(search_term) }).to be_truthy
      end
    end

    context 'when search_term is an empty string' do
      let(:search_term) { '' }

      it 'returns clients matching the empty search term' do
        expect { subject.perform }.to raise_error(ArgumentError, 'Search term cannot be an empty string')
      end
    end

    context 'when searching for the whole string' do
      let(:search_term) { 'john.doe@gmail.com' }

      it 'returns clients matching the whole string' do
        result = subject.perform
        expect(result.all? { |client| client[field.to_sym] == search_term }).to be_truthy
      end
    end

    describe 'case insensitive search' do
      let(:clients) { JSON.parse(load_json_fixture(json_file).to_json, symbolize_names: true) }
      let(:data) do
        {
          id: 1,
          full_name: 'John Doe',
          email: 'john.doe@email.com'
        }
      end
      let(:field) { 'email' }
      let(:search_term) { 'John.Doe@gmail.com' }

      it 'returns clients matching the search term regardless of case' do
        result = subject.perform
        expect(result).to be_a(Array)
        expect(result).not_to be_empty
        expect(result.all? { |client| client[field.to_sym].downcase.include?(search_term.downcase) }).to be_truthy
      end
    end
  end

  describe 'field validation' do
    context 'when the field is valid' do
      let(:field) { Models::Client::VALID_FIELDS.sample }

      it 'does not raise an error' do
        expect { subject.perform }.not_to raise_error
      end
    end

    context 'when the field is invalid' do
      let(:field) { 'invalid_field' }

      it 'raises an error' do
        expect { subject.perform }.to raise_error(ArgumentError, "Invalid field: #{field}")
      end
    end
  end

  describe 'loading clients' do
    context 'when there are existing clients' do
      it 'loads clients successfully' do
        result = subject.perform
        expect(result).to be_a(Array)
        expect(result).not_to be_empty
      end
    end

    context 'when clients array is empty' do
      let(:json_file) { 'spec/fixtures/data/empty_clients.json' }
      it 'does not raise an error' do
        expect { subject.perform }.not_to raise_error
        expect(subject.send(:clients)).to eq([])
      end
    end
  end
end
