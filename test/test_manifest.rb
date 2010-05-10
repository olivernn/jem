require 'helper'

class TestManifest < Test::Unit::TestCase

  def setup
    File.open('manifest.json', 'w') do |f|
      f.write JSON.generate({'project' => 'test', 'file' => 'test.js', 'version' => '0.0.0'})
    end
  end

  def teardown
    File.delete('manifest.json')
  end

  def remove_test_manifest!
    File.delete('manifest.json')
  end

  def create_invalid_manifest!
    File.open('manifest.json', 'w') do |f|
      f.write "invalid!"
    end
  end

  test "creating a new Manifest" do
    remove_test_manifest!

    assert !File.exists?('manifest.json')

    Jem::Manifest.create({
      :project => 'test',
      :file => 'test.js'
    })

    assert File.exists?('manifest.json')
    test_manifest = JSON.parse(File.read('manifest.json'))
    assert_equal test_manifest, {'project' => 'test', 'file' => 'test.js', 'version' => '0.0.0'}
  end

  test "opening an existing manifest" do
    manifest = Jem::Manifest.new
    assert_equal manifest.attributes, {'project' => 'test', 'file' => 'test.js', 'version' => '0.0.0'}
  end

  test "bumping the patch level in the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.patch
    manifest.bump_patch
    assert_equal 1, manifest.patch
  end

  test "bumping the patch level and writing the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.patch
    manifest.bump_patch!
    raw_manifest = JSON.parse(File.read('manifest.json'))
    assert_equal '0.0.1', raw_manifest['version']
  end

  test "bumping the minor level in the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.minor
    manifest.bump_minor
    assert_equal 1, manifest.minor
  end

  test "bumping the minor level and writing the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.patch
    manifest.bump_minor!
    raw_manifest = JSON.parse(File.read('manifest.json'))
    assert_equal '0.1.0', raw_manifest['version']
  end

  test "bumping the major level in the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.major
    manifest.bump_major
    assert_equal 1, manifest.major
  end

  test "bumping the major level and writing the manifest" do
    manifest = Jem::Manifest.new
    assert_equal 0, manifest.major
    manifest.bump_major!
    raw_manifest = JSON.parse(File.read('manifest.json'))
    assert_equal '1.0.0', raw_manifest['version']
  end

  test "throwing an error if the manifest is invalid json" do
    remove_test_manifest!
    create_invalid_manifest!
    assert_raise Jem::InvalidManifest do
      Jem::Manifest.new
    end
  end
end