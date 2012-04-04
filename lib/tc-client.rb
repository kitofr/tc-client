require 'rubygems'
require 'restclient'
require 'rexml/document'
require 'yaml'

class TCClient
  attr_accessor :config, :base_url, :user, :pwd
  def initialize(verbose=true)
    file = File.expand_path('~/.tc-client')
    raise "No configuration file found! Please provide one at #{file}" unless File.exists? file

    @config ||= YAML::load(File.open(file))
    @base_url = config["base_url"]
    @user = config["user"]
    @pwd = config["pwd"]
    @verbose = verbose
  end

  def projects 
    xml = get("/httpAuth/app/rest/projects")
    doc = REXML::Document.new xml
    doc.elements.collect("projects/project") { |p| { :name => p.attributes["name"], :href => p.attributes["href"]}  }
  end

  def builds(project)
    p = projects.select{|x| x[:name].match /#{project}/i }
    return [{:name => "Can't find a project matching '#{project}'"}] if p.empty?
    xml = get(p.first[:href])
    doc = REXML::Document.new xml
    doc.elements.collect("project/buildTypes/buildType") { |b| { :name => b.attributes["name"], :href => b.attributes["href"] } }
  end

  def statuses(project, build)
    b = builds(project).select{|x| x[:name].match /#{build}/i}
    return [{:build => "Can't find a build matching: '#{build}'", :status => "FATAL"}] if b.empty?
    xml = get("#{b.first[:href]}/builds?count=10")
    doc = REXML::Document.new xml
    doc.elements.collect("builds/build") {|x| { :build => x.attributes["number"], :status => x.attributes["status"] } } 
  end

  def get(what)
    verbose("http://#{@user}:#{@pwd}@#{@base_url}#{what}") {|x|
      RestClient.get x
    }
  end

  def verbose(url)
    puts url if @verbose
    yield url if block_given?
  end
end


