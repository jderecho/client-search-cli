# frozen_string_literal: true

class Application
  def self.run_command_line(args)
    Controllers::CommandLine.start(args)
  end
end
