require 'slack-ruby-bot'
require 'money'
require_relative 'APIRequest' 

class PongBot < SlackRubyBot::Bot
  # all commands for the bot
  PING = 'ping'
  PONG = 'pong'
  SALES_INVOICES = 'wanbetalers'
  PURCHASE_INVOICES = 'facturen'
  PURCHASE_INVOICES_LATE = 'verlopen_facturen'
  # end of commands
  # token and used administration in moneybird
  TOKEN = 'c738c0deba0d1119a67aa91ee051225481beb977fc9643adaac1a87433732ac2'
  ADMINISTRATION = '186311193805194935'

  help do
  title 'Sybes bot'
  desc 'Moneybird bot voor slack.'

    command PING do  
      desc ''
    end

    command PONG do
      desc ''
    end

    command PURCHASE_INVOICES do
      desc 'facturen'
      long_desc 'Geeft alle nog openstaande facturen'
    end

    command SALES_INVOICES do
      desc 'wanbetalers'
      long_desc 'Geeft alle verkoopfacturen die te laat betaald zijn'
    end

    command PURCHASE_INVOICES_LATE do
      desc 'verlopen facturen'
      long_desc 'Geeft alle inkoopfacturen die te laat betaald zijn'
    end

  end
  command PING do |client, data, match|
    client.say(text: ':table_tennis_paddle_and_ball:', channel: data.channel)
  end
  command PONG do |client, data, match|
    client.say(text: ':table_tennis_paddle_and_ball:', channel: data.channel)
  end
  command PURCHASE_INVOICES do |client, data, match|
    req = APIRequest.new TOKEN, ADMINISTRATION
    result = req.purchase_invoices
    if result.length == 0
      client.say(text: 'Geen openstaande inkoopfacturen', channel: data.channel)
    else
      result.each do |r|
        client.say(text: r, channel: data.channel) unless r.nil?
      end
    end
  end
  command PURCHASE_INVOICES_LATE do |client, data, match|
    req = APIRequest.new TOKEN, ADMINISTRATION
    result = req.purchase_invoices_late
    if result.length == 0
      client.say(text: 'Geen te laat betaalde inkoopfacturen', channel: data.channel)
    else
      result.each do |r|
        client.say(text: r, channel: data.channel) unless r.nil?
      end
    end
  end
  command SALES_INVOICES do |client, data, match|
    req = APIRequest.new TOKEN, ADMINISTRATION
    result = req.sale_invoices
    if result.length == 0
      client.say(text: 'Geen te laat betaalde verkoopfacturen', channel: data.channel)
    else
      result.each do |r|
        client.say(text: r, channel: data.channel) unless r.nil?
      end
    end
  end
  command 'emoji' do |client, data, match|
    client.say(text: ':' + data[:text].split(' ')[1] + ':', channel: data.channel)unless data[:text].split(' ').length < 2
  end
end

# Set logging level to warn
SlackRubyBot::Client.logger.level = Logger::WARN
PongBot.run