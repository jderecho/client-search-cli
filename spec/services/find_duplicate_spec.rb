# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Services::FindDuplicate do
  let(:json_file) { 'spec/fixtures/data/test_clients.json' }
  let(:data) { JSON.parse(load_json_fixture(json_file).to_json, symbolize_names: true) }
  subject { described_class.new(data, field) }

  describe '#find_duplicates' do
    let(:field) { 'email' }

    context 'finds duplicate emails' do
      context 'when duplicates exist' do
        # Assuming the return format is a hash with the email as the key
        # and array of duplicate client hashes as the value
        it 'returns duplicates' do
          expected_result = {
            'jane.smith@yahoo.com' => [
              {
                email: 'jane.smith@yahoo.com',
                full_name: 'Jane Smith',
                id: 2
              },
              {
                email: 'jane.smith@yahoo.com',
                full_name: 'Test Jane Smith',
                id: 4
              }
            ]
          }
          expect(subject.perform).to eq(expected_result)
        end
      end

      context 'when no duplicates exist' do
        let(:json_file) { 'spec/fixtures/data/no_duplicates.json' }

        it 'returns an empty hash' do
          expect(subject.perform).to eq({})
        end
      end

      context 'when clients json is empty' do
        let(:json_file) { 'spec/fixtures/data/empty_clients.json' }

        it 'returns an empty hash' do
          expect(subject.perform).to eq({})
        end
      end
    end

    describe 'loading clients' do
      let(:field) { 'email' }

      context 'when there are existing clients' do
        it 'loads clients successfully' do
          result = subject.perform
          expect(result).to be_a(Hash)
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

  describe '#validate_fields!' do
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

    context 'when the field is nil' do
      let(:field) { nil }

      it 'raises an error' do
        expect { subject.perform }.to raise_error(ArgumentError, 'Field cannot be nil')
      end
    end
  end
end
