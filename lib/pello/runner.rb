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

    def file_log(text)
      File.open(config.log_file, 'a+') do |file|
        file.puts(text)
      end
    end

    def add_pomodori_to_card
      board = Pello::Inputs.choose_board config.user, config.board_url
      puts board.as_table
      list = Pello::Inputs.choose_list board, config.list_name
      card = Pello::Inputs.choose_card list

      Trello::Comment.define_method :action_id do
        id
      end

      pomodori_before = card.extract_pomodori
      pomodori_to_add = prompt.ask('Pomodori', default: 1)

      puts "Updating card #{card.name}"
      puts "New title:    #{card.title_with_added_pomodori(pomodori_to_add.to_i)}"

      if prompt.yes?('Confirm?')
        card.name = card.title_with_added_pomodori(pomodori_to_add.to_i)
        card.save
        file_log "[#{Time.now} - #{config.user.full_name}] #{card.extract_title} (#{pomodori_before} -> #{card.extract_pomodori})"
        card.log "[#{Time.now} - #{config.user.full_name}] #{card.extract_title} (#{pomodori_before} -> #{card.extract_pomodori})"
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
