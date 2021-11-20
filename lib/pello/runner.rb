require 'yaml'
require 'trello'

module Pello
  class Runner
    attr_accessor :config

    def initialize
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

      print '(pomodori) > '
      pomodori_to_add = gets.chomp || 1

      puts "Updating card #{card.name}"
      puts "New title:    #{card.add_pomodori(pomodori_to_add.to_i)}"

      Choice.new(valid_options: %w[y], message: 'Confirm? (y/n)').run(
        lambda do |_input|
          card.name = card.add_pomodori(pomodori_to_add.to_i)
          # card.save
          log "[#{Time.now}] #{card.extract_title} (#{card.extract_pomodori})"
          puts('Done!')
        end,
        -> { puts 'Ok, bye!' and return nil }
      )
    end

    private

    def configure_trello
      @config = Pello::Config.new
    end
  end
end
