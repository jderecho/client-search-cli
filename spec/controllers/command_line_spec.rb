# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controllers::CommandLine do
  let(:clients_data) { [{ 'id' => 1, 'full_name' => 'Alice', 'email' => 'test@email.com' }] }
  let(:parsed_data) { JSON.parse(clients_data.to_json, symbolize_names: true) }

  describe '#search' do
    before do
      allow(Services::LoadJson).to receive(:new).and_return(double(perform: parsed_data))
    end

    it 'loads clients and calls Services::Search with correct args' do
      expect do
        described_class.start(%w[search full_name Alice])
      end.to output("{:id=>1, :full_name=>\"Alice\", :email=>\"test@email.com\"}\n").to_stdout
    end

    context 'when search term is not found' do
      it 'returns empty result' do
        expect do
          described_class.start(%w[search full_name Bob])
        end.to output("No results found\n").to_stdout
      end
    end

    context 'when search term is not provided' do
      it 'prints error message' do
        error = "ERROR: \"rspec search\" was called with arguments [\"full_name\"]\n"
        usage = "Usage: \"rspec search FIELD QUERY\"\n"

        expect do
          described_class.start(%w[search full_name])
        end.to output([error, usage].join).to_stdout
      end
    end

    context 'when field is invalid' do
      it 'returns empty result' do
        expect do
          described_class.start(%w[search name Bob])
        end.to output("Invalid field: name\n").to_stdout
      end
    end

    context 'when field is not provided' do
      it 'prints error message' do
        error = "ERROR: \"rspec search\" was called with no arguments\n"
        usage = "Usage: \"rspec search FIELD QUERY\"\n"

        expect do
          described_class.start(%w[search])
        end.to output([error, usage].join).to_stdout
      end
    end
  end

  describe '#find_duplicates' do
    let(:clients_data) do
      [
        { id: 1, full_name: 'Alice', email: 'test@email.com' },
        { id: 2, full_name: 'Duplicate Alice', email: 'test@email.com' }
      ]
    end

    before do
      allow(Services::LoadJson).to receive(:new).and_return(double(perform: parsed_data))

      @expected_result = {}
      clients_data.each do |client|
        @expected_result[client[:email]] ||= []
        @expected_result[client[:email]] << client
      end
    end

    it 'loads clients and calls Services::FindDuplicate with correct args' do
      expect do
        described_class.start(%w[find_duplicates email])
      end.to output("#{@expected_result}\n").to_stdout
    end

    context 'when no duplicates are found' do
      let(:clients_data) do
        [
          { id: 1, full_name: 'Alice', email: 'test@email.com' },
          { id: 2, full_name: 'Lisa', email: 'test2@email.com' }
        ]
      end

      it 'returns empty result' do
        expect do
          described_class.start(%w[find_duplicates email])
        end.to output("No results found\n").to_stdout
      end
    end
  end

  describe '#invoke_command error handling' do
    before do
      allow(Services::LoadJson).to receive(:new).and_return(double(perform: parsed_data))
    end

    it 'handles exceptions and prints error message' do
      expect do
        described_class.start(%w[search name Alice])
      end.to output(/Invalid field: name/).to_stdout
    end
  end

  describe 'load_json_file' do
    context 'when file option is provided' do
      let(:clients_data) do
        [
          { id: 1, full_name: 'John', email: 'john@test.com' }
        ]
      end

      it 'loads the JSON file' do
        expect(Services::LoadJson).to receive(:new).with('path/to/file.json').and_return(double(perform: clients_data))
        expect do
          described_class.start(%w[search full_name John --file path/to/file.json])
        end.to output("#{clients_data.first}\n").to_stdout
      end

      context 'when the file does not exist' do
        it 'raises an error' do
          expect do
            described_class.start(%w[search full_name John --file non_existent_file.json])
          end.to output(/File does not exist: non_existent_file.json/).to_stdout
        end
      end
    end

    context 'when file option is not provided' do
      it 'it loads the default file' do
        allow(Services::LoadJson).to receive(:new).and_return(double(perform: parsed_data))
        expect do
          described_class.start(%w[search full_name Alice])
        end.to output("{:id=>1, :full_name=>\"Alice\", :email=>\"test@email.com\"}\n").to_stdout
      end
    end
  end
end
