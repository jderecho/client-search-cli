# frozen_string_literal: true

require_relative '../spec_helper'

describe Services::LoadJson do
  subject { described_class.new(json_file) }

  let(:json_file) { 'spec/fixtures/data/test_clients.json' }

  context 'when the file is valid' do
    it 'loads the JSON file successfully' do
      result = subject.perform
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end
  end

  context 'when the file is invalid' do
    let(:json_file) { 'spec/fixtures/data/invalid_format.json' }

    it 'raises an error' do
      expect do
        subject.perform
      end.to raise_error(ArgumentError,
                         "Failed to parse JSON file: #{json_file}. Error: unexpected character: 'invalid json'")
    end
  end

  context 'when the file does not exist' do
    let(:json_file) { 'spec/fixtures/data/non_existent_file.json' }

    it 'raises an error' do
      expect { subject.perform }.to raise_error(ArgumentError, "File does not exist: #{json_file}")
    end
  end

  context 'when the file is empty' do
    let(:json_file) { 'spec/fixtures/data/empty_clients.json' }

    it 'does not raise an error' do
      expect { subject.perform }.to_not raise_error
    end

    it 'returns an empty array' do
      result = subject.perform
      expect(result).to be_a(Array)
      expect(result).to be_empty
    end
  end
end
