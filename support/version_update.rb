require "date"
require "json"
require "net/http"

def update_file(name)
  data = IO.read(name)
  updated = yield data
  IO.write(name, updated)
end

raise "missing current AWS_CLI_VERSION parameter" if ARGV.length == 0

current_version = Gem::Version.new(ARGV[0])

# Get the ten most recent tags. If "latest" is not one of these, fail.
tags_uri = URI.parse("https://hub.docker.com/v2/repositories/amazon/aws-cli/tags")
tags = JSON.parse(Net::HTTP.get(tags_uri))

latest_image = tags["results"].find { _1["name"] == "latest" }
raise "Could not find 'amazon/aws-cli:latest' tag." unless latest_image

latest_digest = latest_image["digest"]
new_tag = tags["results"].find {
  !["latest", "arm64", "amd64"].include?(_1["name"]) &&
    _1["digest"] == latest_digest
}
raise "Could not find a version tag for 'amazon/aws-cli:latest'." unless new_tag

new_version = Gem::Version.new(new_tag["name"])

# If the "latest" version is not actually newer than the current version, fail.
if new_version <= current_version
  raise "Version tag for 'amazon/aws-cli:latest' (#{new_version}) is the same as current version (#{current_version})"
end

today = Date.today.strftime("%Y-%m-%d")
release_header = "#{new_version} / #{today}"
history_body = "Automatic update to amazon/aws-cli:#{new_version}"

update_file ".github/workflows/update-base-image.yml" do |file|
  file.sub(/AWS_CLI_VERSION: ['"][.0-9]+['"]/, "AWS_CLI_VERSION: '#{new_version}'")
end

update_file "Dockerfile" do |file|
  file.sub(/AWS_CLI_VERSION=[.0-9]+/, "AWS_CLI_VERSION=#{new_version}")
end

update_file "Justfile" do |file|
  file.sub(/AWS_CLI_VERSION := ['"][.0-9]+['"]/, "AWS_CLI_VERSION := '#{new_version}'")
end

update_file "aws-cli-session-manager" do |file|
  file.sub(/\{AWS_CLI_VERSION:-[.0-9]+\}/, "{AWS_CLI_VERSION:-#{new_version}}")
end

update_file "README.md" do |file|
  file.gsub(":#{current_version}", ":#{new_version}")
    .gsub("=#{current_version}", "=#{new_version}")
end

update_file "Changelog.md" do |file|
  file.sub("<!-- automatic-release -->\n", <<~NOTE)
    <!-- automatic-release -->

    ## #{release_header}

    - #{history_body}
  NOTE
end

body = <<~EOF_GITHUB_ENV
  UPDATE_VERSION=#{new_version}
  UPDATE_TITLE=Update amazon/aws-cli base image #{release_header}
  UPDATE_BODY=#{history_body}
EOF_GITHUB_ENV

puts body

File.write(ENV["GITHUB_ENV"], body, mode: "a+") if ENV.key?("GITHUB_ENV")
