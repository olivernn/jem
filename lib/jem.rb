require 'uri'

require 'highline'
require 'json'
require 'rest_client'
require 'signature'

module Jem
  HOST = 'http://10.9.8.231:3000'

  class << self
    @host = HOST.dup

    attr_accessor :host
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/jem')

require 'jem/auth'
require 'jem/command'
require 'jem/errors'
require 'jem/manifest'
require 'jem/project'
require 'jem/push'
