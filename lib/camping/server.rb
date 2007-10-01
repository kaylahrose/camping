require 'camping/reloader'

module Camping::Server
class Base < Hash
  include Enumerable
  
  attr_reader :paths
  attr_accessor :conf
  
  def initialize(conf, paths = [])
    unless conf.database
      raise "!! No home directory found.  Please specify a database file, see --help."
    end
    
    @conf = conf
    Camping::Reloader.database = conf.database
    Camping::Reloader.log = conf.log
    
    @paths = []
    paths.each { |script| add_app script }
    # TODO exception instead of abort()
    # abort("** No apps successfully loaded") unless self.detect { |app| app.klass }
    
  end

  def add_app(path)
    @paths << path
    if File.directory? path
        Dir[File.join(path, '*.rb')].each { |s| insert_app(s)}
    else
        insert_app(path)
    end
    # TODO check to see if the application is created or not... exception perhaps?
  end
  
  def find_new_scripts
      self.values.each { |app| app.reload_app }
      @paths.each do |path|
          Dir[File.join(path, '*.rb')].each do |script|
              smount = File.basename(script, '.rb')
              next if detect { |x| x.mount == smount }
  
              puts "** Discovered new #{script}"
              # TODO hmm. the next should be handled by the add_app thingy
              app = insert_app(script)
              next unless app
  
              yield app
              
          end
      end
      self.values.sort! { |x, y| x.mount <=> y.mount }
  end
  def index_page
      welcome = "You are Camping"
      apps = self
      <<-HTML
<html>
  <head>
    <title>#{welcome}</title>
    <style type="text/css">
      body { 
        font-family: verdana, arial, sans-serif; 
        padding: 10px 40px; 
        margin: 0; 
      }
      h1, h2, h3, h4, h5, h6 {
        font-family: utopia, georgia, serif;
      }
    </style>
  </head>
  <body>
    <h1>#{welcome}</h1>
    <p>Good day.  These are the Camping apps you've mounted.</p>
    <ul>
      #{apps.values.select{|app|app.klass}.map do |app|
        "<li><h3 style=\"display: inline\"><a href=\"/#{app.mount}\">#{app.klass.name}</a></h3><small> / <a href=\"/code/#{app.mount}\">View source</a></small></li>"
      end.join("\n")}
    </ul>
  </body>
</html>
      HTML
  end
  
  def each(&b)
      self.values.each(&b)
  end

  # for RSpec tests
  def apps
      self.values
  end
  
  private
  
  def insert_app(script)
    self[script] = Application.new(script)
  end
end

class Application < Camping::Reloader
end
end

