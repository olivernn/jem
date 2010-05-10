module Jem
  module Command
    class << self
      attr_accessor :host

      def run(command)
        if namespaced? command
          Jem::Command.const_get(namespace_from(command).capitalize).send(method_from(command))
        else
          send(command)
        end
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
        puts "hello!"
      end

      private

      def namespaced? command
        !!command.match(/:/)
      end

      def namespace_from command
        parse(command)[0]
      end

      def method_from command
        parse(command)[1]
      end

      def parse command
        command.split(':')
      end

    end
  end
end
