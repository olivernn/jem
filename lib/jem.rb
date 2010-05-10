require 'rubygems'
require 'uri'
require 'highline'
require 'json'
require 'rest_client'
require 'signature'

module Jem
  
  class << self
    attr_accessor :host
  end
end

Jem.host = 'http://localhost:3000'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/jem')

require 'jem/auth'
require 'jem/command'
require 'jem/errors'
require 'jem/manifest'
require 'jem/project'
require 'jem/push'
require 'jem/command/version'
