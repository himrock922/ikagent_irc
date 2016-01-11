=begin
ikagent(IRC Client)
=end

############################
# Definition of the library
require 'optparse/uri'
require 'securerandom'
require 'irc-socket'
############################
OPTS = {}

###############
# IRC Setting #
###############

SERVER = "irc.livedoor.ne.jp"
PORT = Random::rand(6660...6667)
NICK = SecureRandom::hex(9)

#########
# Start #
#########

class Ikagent_IRC
  Signal.trap(:INT) {
    exit
  }
  # thread for read data
  @@readn = Thread::fork do
    Thread::stop
    while msg = @@irc.read
      puts msg
    end
  end

  # thread for send data
  @@writen = Thread::fork do
    Thread::stop
    while msg = gets.chomp
      case msg
      when  /^exit/i
        exit
      end
    end
  end
  private
  # function to store of such options args
  def options_setting
    if OPTS[:s] then @@server = OPTS[:s] else @@server = SERVER end
    if OPTS[:p] then @@port = OPTS[:p].to_i else @@port = PORT.to_i end
    if OPTS[:n] then @@nick = OPTS[:n] else @@nick = NICK end

    # channel character (no # or head #)
    if OPTS[:c] then
      channel = OPTS[:c]
      if channel.start_with?("#") == false then
        @@channel = "#" + channel
      else
        @@channel = channel
      end
    else
      @@channel = ""
    end
    if OPTS[:t] then @@topic = OPTS[:t] else @@topic = "" end
  end
  ########################################
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
    options_setting
    @@irc = IRCSocket.new(@@server, @@port)
    @@irc.connect

    if @@irc.connected?
      @@irc.nick "#{@@nick}"
      @@irc.user "#{@@nick}", 0, "*", "I am #{@@nick}"
    end

    # process select write and read
    @@readn.run
    @@writen.run
    @@writen.join
    @@readn.join
  end
end

Ikagent_IRC::new
