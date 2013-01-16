require 'cinch'

class Seen < Struct.new(:who, :where, :what, :time)
  def to_s
    "[#{time}] #{who} was seen in #{where} saying #{what}"
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = 'irc.freenode.org'
    c.channels = ["#5by5", "#5by5bottest"]
    c.nick = 'seenbot'

    @users = {}
  end

  # Only log channel messages
  on :channel do |m|
    if @users.nil?
       @users = {}
       puts( 'Initializing users hash' )
    end
    @users[m.user.nick] = Seen.new(m.user.nick, m.channel, m.message, m.time.to_s)
  end

  on :channel, /^!seen (.+)/ do |m, nick|
    if nick == bot.nick
      m.reply "That's me!"
    elsif nick == m.user.nick
      m.reply "That's you!"
    elsif @users.key?(nick)
      m.reply @users[nick].to_s
    else
      m.reply "I haven't seen #{nick}"
    end
  end
end

bot.start
