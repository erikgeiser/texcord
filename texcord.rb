#!/usr/bin/env ruby

require 'discordrb'
require 'json'
require 'calculus'

# ========================== SETUP ==========================

begin
  config = JSON.parse(File.read("config.json"))
rescue Exception => msg
  puts "Config could not be parsed"
  exit
end


# Bot initialization
bot = Discordrb::Commands::CommandBot.new config["mail"], config["password"], "!", "command_doesnt_exist_message": nil #TODO login with token
bot.debug = false
# ===========================================================




# ========================= HANDLER =========================
bot.command :tex do |event, *args|
  event.message.delete
  puts "[*] Converting #{args.join(" ")}"
  begin
    expr = Calculus::Expression.new(args.join(" "),parse: false)
    file = File.new(expr.to_png)
    event.channel.send_file(file)
    File.delete(file.path)
  rescue Exception => msg
    event.respond "Latex error:"
    event.respond msg
  end
  nil
end




begin
  bot.run :async
  puts "[*] Bot started"
  bot.sync
rescue Exception
  puts "[!] Stopping Bot..."
end
