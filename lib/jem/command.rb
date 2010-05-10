module Jem
  class Command
    class << self
      attr_accessor :host

      def run(command)
        send(command)
      end

      def init
        @highline = HighLine.new
        options = {}
        options[:project] = @highline.ask('project name: ')
        options[:file] = @highline.ask('file name: ')
        Jem::Manifest.create(options)
      end

      def push
        auth = Jem::Auth.new
        auth.confirm_credentials

        project = Jem::Project.new

        Jem::Push.new(auth, project).push
      end

      def hello
        puts "Hello"
      end
    end
  end
end
