# frozen_string_literal: true

module FixtureHelper
  def load_json_fixture(file_path)
    JSON.parse(File.read(file_path))
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
