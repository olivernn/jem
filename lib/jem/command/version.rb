module Jem
  module Command
    class Version
      class << self
        [:major, :minor, :patch].each do |level|
          define_method "bump_#{level}" do
            manifest = Jem::Manifest.new
            manifest.send("bump_#{level}!")
            puts "current version now at #{manifest.current_version}"
          end
        end
      end
    end
  end
end
