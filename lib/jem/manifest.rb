module Jem
  class Manifest

    MANIFEST_FILE_NAME = 'manifest_test.json'

    def self.create(options)
      File.open(MANIFEST_FILE_NAME, 'w') do |f|
        f.write JSON.generate(options.merge({ :version => '0.0.0' }))
      end
    end

  end
end