=begin
ikagent(IRC Client)
=end

############################
# Definition of the library
require 'optparse'
require 'irc-socket'
############################
OPTS = {}
#########
# Start #
#########

class Ikagent_IRC
  def initialize
    opt = OptionParser::new
    begin
      ###################
      # Specific option #
      # specify the connection server (hostname or ip address)
      opt.on('-s SERVER', '-s hostname(ip address)') {|v| OPTS[:s] = v }
      # specify the portnumber
      opt.on('-p PORT', '-p portnumber') {|v| OPTS[:p] = v }
      # specify the nickname
      opt.on('-n NICK', '-n nickname') {|v| OPTS[:n] = v }
      # specify the join channelname
      opt.on('-c CHANNEL', '-c channelname') {|v| OPTS[:c] = v }
      # specify the topic to joined channel
      opt.on('-t TOPIC', '-t topicname') {|v| OPTS[:t] = v }
      ##################
      opt.parse!(ARGV)
    # error process
    rescue => evar
      p evar
      exit
    end
    ###############
  end
end

Ikagent_IRC::new
