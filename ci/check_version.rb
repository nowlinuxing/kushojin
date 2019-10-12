require 'rubygems'
require 'net/http'
require 'json'

if ARGV.size != 1
  $stderr.puts "Usage: #{$PROGRAM_NAME} GEMNAME"
  exit 1
end
name = ARGV.first

local_version = Gem::Specification.load("#{name}.gemspec")&.version
raise "Couldn't get the local version." if local_version.nil?
puts "Local version: #{local_version}"

remote_version =
  begin
    uri = URI.parse("https://api.rubygems.org/api/v1/versions/#{name}/latest.json")
    version = JSON.parse(Net::HTTP.get(uri))["version"]
    raise "Couldn't get the remote version." if version.nil? || version.empty?

    Gem::Version.new(version)
  end
puts "Remote version: #{remote_version}"

exit local_version > remote_version
