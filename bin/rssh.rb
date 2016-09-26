#!/usr/bin/env ruby

require 'etc'
require 'net/ssh'
require 'net/scp'
require 'highline/import'
require 'trollop'




class Parser

  def initialize()
    @hostname = ''
    @username = ''
    @configfile = ''
  end
    
  def parse()
    opts = Trollop::options do
      opt :debug, "Debug Mode"
      opt :conffile, "Specify Config file if not using default", :type => :string
      opt :username, "Specify Username to use for SSH Connections. Defaults to logged in username", :type => :string
      opt :hostname, "Specify Hostname to use for SSH Connections", :type => :string
    end

    # Validating existence of username
    # If not present getting it from system
    if not opts[:username].nil?
      @username = opts[:username]
    else
      @username = Etc.getlogin()
    end  

    # Hostname should be 2nd arg (ie after scriptname)
    # If --hostname is given it overrides 2nd arg
    # if neither argument or option was passed, we better exit
    
    if not opts[:hostname].nil?
      @hostname = opts[:hostname]
    elsif opts[:hostname].nil? and not ARGV[0].nil?
      @hostname = ARGV[0]
    elsif opts[:hostname].nil? and ARGV[0].nil?
      puts "Hostname not specified"
      exit 2
    end

    # Config file presence

    baseDir = File.dirname(__FILE__)  + '/..'
    if not opts[:conffile].nil?
      @conffile = opts[:conffile]
    else
      @conffile = "#{baseDir}/conf/source.files"
    end

    return @hostname, @username, @conffile

  end # parse() method ends

end


class SSHProfileCopy
  attr_reader :hostname, :confFile, :username

  def initialize(hostname, username, confFile)
    @hostname = hostname
    @confFile = confFile
    @fileList = []
    self.getFileList(@confFile)
  end


  def getFileList(confFile)
    puts "Yeah the conf file is #{@confFile}"
    puts File.read(@confFile)
  end

  def getSSHCredentials

  end

  def generateSSHConnection()
    @hostname
  end
  
  def getRemoteProfileVersion(hostname)

  end
  
  def doSCP(hostname, sourceFilePath)
    
  end  

end

parser  = Parser.new
host, user, conf = parser.parse()
puts host, user, conf

sshCopier = SSHProfileCopy.new(host, user, conf)
# p sshCopier
# p sshCopier.hostname