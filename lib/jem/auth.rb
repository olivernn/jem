module Jem
  class Auth
    attr_reader :highline
    attr_accessor :email, :key, :password, :secret

    CREDENTIALS_FILE_PATH = File.join(ENV['HOME'], '.jem')

    def initialize
      @highline = HighLine.new
    end

    def confirm_credentials
      read_credentials || login
    end

    private

    def login
      ask_for_login
      new_credentials = RestClient.put "#{Jem::HOST}/api/accounts", {
        :email => email, :password => password
      }
      puts new_credentials.inspect
      write_credentials(new_credentials)
    end

    def ask_for_login
      @email = @highline.ask('email: ')
      @password = @highline.ask('password: ') { |q| q.echo = false }
    end

    def read_credentials
      if File.exists?(CREDENTIALS_FILE_PATH)
        credentials = JSON.parse(File.read(CREDENTIALS_FILE_PATH))

        @key = credentials['key']
        @secret = credentials['secret']

        true
      else
        false
      end
    end
    
    def write_credentials(blah)
      File.open(CREDENTIALS_FILE_PATH, 'w') do |f|
        f.write blah
      end
    end
  end
end