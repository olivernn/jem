module Jem
  class Manifest

    MANIFEST_FILE_NAME = 'manifest.json'

    attr_reader :attributes

    def initialize
      @attributes = JSON.parse(File.read(MANIFEST_FILE_NAME))
    rescue JSON::ParserError
      raise Jem::InvalidManifest
    end

    def self.create(options)
      File.open(MANIFEST_FILE_NAME, 'w') do |f|
        f.write JSON.generate(options.merge({ :version => '0.0.0' }))
      end
    end

    def current_version
      "#{major}.#{minor}.#{patch}"
    end

    [:major, :minor, :patch].each_with_index do |level, index|
      define_method level do
        instance_variable_get("@#{level}") || instance_variable_set("@#{level}", @attributes['version'].split('.')[index].to_i)
      end

      define_method "bump_#{level}" do
        instance_variable_set("@#{level}", send(level) + 1)
      end

      define_method "bump_#{level}!" do
        send("bump_#{level}")
        save!
      end
    end

    def save!
      File.open(MANIFEST_FILE_NAME, 'w') do |f|
        f.write JSON.generate(@attributes.merge({'version' => current_version}))
      end
    end
  end
end