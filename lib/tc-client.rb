require 'rubygems'
require 'restclient'
require 'rexml/document'
require 'yaml'

def config 
  file = File.expand_path('~/.tc-client')
  raise "No configuration file found! Please provide one at #{file}" unless File.exists? file
  @config ||= YAML::load(File.open(file))
end

def projects 
  config["projects"].to_hash
end

class TCClient
  def initialize(project)
    @count = 10
    @project = projects[project]

    @base_url = config["base_url"]
    puts "last #{@count} (successful) builds for #{project} (#{@project})"
    @user = config["user"]
    @pwd = config["pwd"]
  end

  def builds
    xml = RestClient.get "http://#{@user}:#{@pwd}@#{@base_url}/httpAuth/app/rest/buildTypes/id:#{@project}/builds?status=SUCCESS&count=#{@count}"
    doc = REXML::Document.new xml
    builds = []
    doc.elements.each("builds/build") do |build|
      builds << build.attributes["number"]
    end
    builds
  end
end

