# frozen_string_literal: true

require 'byebug'
require 'zeitwerk'
require 'thor'
require 'json'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib")
loader.setup

require_relative 'application'
