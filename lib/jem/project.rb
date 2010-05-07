module Jem
  class Project
    attr_reader :manifest

    def initialize
      read_manifest
    end

    def file
      @file ||= File.read(File.join(Dir.pwd, file_name))
    end

    def file_name
      JSON.parse(manifest)['file']
    end

    private
      def read_manifest
        file = File.join(Dir.pwd, 'manifest.json')
        @manifest = File.read(file)
      end
  end
end
