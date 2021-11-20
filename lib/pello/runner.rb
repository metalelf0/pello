require 'yaml'
require 'trello'
require 'tty-prompt'

module Pello
  class Runner
    attr_accessor :config, :prompt

    def initialize
      @prompt = TTY::Prompt.new
      configure_trello
    end

    def log(text)
      File.open(config.log_file, 'a+') do |file|
        file.puts(text)
      end
    end

    def add_pomodori_to_card
      list = Pello::Inputs.choose_list(config.user, config.board_url, config.list_name)
      card = Pello::Inputs.choose_card(list)
      pomodori_to_add = prompt.ask('Pomodori', default: 1)

      puts "Updating card #{card.name}"
      puts "New title:    #{card.add_pomodori(pomodori_to_add.to_i)}"

      if prompt.yes?('Confirm?')
        card.name = card.add_pomodori(pomodori_to_add.to_i)
        # card.save
        log "[#{Time.now}] #{card.extract_title} (#{card.extract_pomodori})"
        puts('Done!')
      else
        puts 'Ok, bye!'
        nil
      end
    end

    private

    def configure_trello
      @config = Pello::Config.new
    end
  end
end
