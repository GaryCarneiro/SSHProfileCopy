#!/usr/bin/env ruby

require 'etc'
require 'net/ssh'
require 'net/scp'
require 'highline/import'
require 'trollop'

class Parser
    
  def parse()
    opts = Trollop::options do
      opt :debug, "Debug Mode"
      opt :conffile, "Specify Config file if not using default", :type => :string
      opt :username, "Specify Username to use for SSH Connections. Defaults to logged in username", :type => :string
      opt :hostname, "Specify Hostname to use for SSH Connections", :type => :string
    end
  
    if opts[:username].nil?
      username = Etc.getlogin()
    end  
  
    if opts[:hostname].nil?
      opts[:hostname] = ARGV[0]
    end  
  
    return opts
  end
    
end


class SSHProfileCopy
  attr_reader :hostname, :confFile, :username
  
  
  def initialize(hostname, confFile, username=nil)
    @hostname = hostname
    @confFile = confFile
    @fileList = []   
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
puts parser.parse()


=begin
sshCopier = SSHProfileCopy.new('inw-1', '/tmp/1')
p sshCopier
p sshCopier.hostname
=end