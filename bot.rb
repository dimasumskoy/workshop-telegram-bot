require 'telegram/bot'

class FinanceBot
  TOKEN = ''

  def run
    Telegram::Bot::Client.run(TOKEN) do |bot|
      @bot = bot

      @bot.listen do |message|
        case message.text
        when /start/i
          reply(message, "Hi, #{message.from.first_name}!")
        when /save/i
          save_data(message)
          reply(message, 'Saved!')
        when /transactions/i
          reply(message, read_data('transactions.txt'))
        else
          reply(message, "What?")
        end
      end
    end
  end

  private

  def read_data(file_path)
    File.new(file_path).read
  end

  def save_data(message)
    text = message.text.sub('/save', '')
    text.prepend(Time.now.strftime("%d.%m.%Y %H:%M"))

    File.open('transactions.txt', 'a+') do |file|
      file.puts text
    end
  end

  def reply(message, text)
    @bot.api.send_message(chat_id: message.chat.id, text: text)
  end
end

FinanceBot.new.run
