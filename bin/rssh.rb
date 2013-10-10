#!/usr/bin/env ruby

require 'net/ssh'                               # Bring on the Real Hardworker
require 'net/scp'                               # This guy does 10% Hardwork
require 'highline/import'                       # Required to get password without echo'ing

$PSWD = nil

if ARGV[0].nil? 
    print "Hostname blank\n"                      # Exit if no hostname is passed #FIXME Put a --help like example
    exit 1
else
    $hostname = ARGV[0]                         #  Mandatory 
end

BASEDIR = File.dirname(__FILE__)  + '/..' 

$file_list = ["#{BASEDIR}/profile/version","#{BASEDIR}/profile/bash_profile","#{BASEDIR}/profile/vimrc"]        #Profile files

if ARGV[1].nil?                                 # Is Username passed ??
    require 'etc'                             
    $userid = Etc.getlogin()                    # No ?? Get username from system       
    print "UserID: " + $userid + "\n"
else
    $userid = ARGV[1].chomp                     # Oh so its passed !! Sanitise it !!
end

LOCALVERSION = File.read($file_list[0]).to_i    # Read, Convert and Close the file
print "LOCALVERSION:", LOCALVERSION, "\n"       # Profile's Local version Incremented everytime you change the profile files

def askPassword(prompt="Enter Password : ")
   ask(prompt) {|q| q.echo = false}
end


def genSSHObject(host)
  begin
      $ssh = Net::SSH.start(host, $userid)
      return $ssh
  rescue Net::SSH::AuthenticationFailed       #FIXME Get more exceptions
      begin
          $PSWD = askPassword() if $PSWD.nil?
          $ssh = Net::SSH.start(host, $userid, :password => $PSWD, :paranoid => Net::SSH::Verifiers::Null.new)
          return $ssh
      rescue Net::SSH::AuthenticationFailed
          print "Password Auth too Failed. Exiting..."
          exit 1
      end
  end 
end

def getVersion(host)                            # Get Remote Profile version
        current_version = $ssh.exec! "cat ~/.version"
        return current_version
end

def do_SCP(host)                                # Do the  SCP work
    print "SCP'ing " +  $userid + "@" + host + "\n"

    $file_list.each do |filename|
        #puts File.exists? filename
        rpath = "./." + File.basename(filename)
        print "Uploading " + filename  + " as " + rpath + "\n"
        $ssh.scp.upload! filename, rpath         # Do the SCP thing  !!
    end
    
end

genSSHObject($hostname)                         #Get $ssh object or exit 

REMOTEVERSION = getVersion(host = $hostname).to_i       
print "REMOTEVERSION:" ,REMOTEVERSION, "\n"

if REMOTEVERSION < LOCALVERSION                 
    do_SCP(host = $hostname)                    # Do whatcha born for !!
else 
    print "Skipping Profile Copy \n"            # Phew !! Nothing to do here 
end

print "SSHing now ..\n"

system '/usr/bin/ssh', $hostname                # Execute ssh
