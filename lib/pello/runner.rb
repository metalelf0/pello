require 'yaml'
require 'trello'

module Pello
  class Runner
    CONFIG_FILE_PATH = "#{ENV['HOME']}/.config/pello/pello.yaml".freeze
    attr_accessor :user, :board_url, :list_name, :log_file

    def initialize
      configure_trello
    end

    def log(text)
      File.open(log_file, 'a+') do |file|
        file.puts(text)
      end
    end

    def add_pomodori_to_card
      list = Pello::Inputs.choose_list(user, board_url, list_name)
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
        config = YAML.safe_load File.open(CONFIG_FILE_PATH).read
        authentication = config['auth']
        pello_config   = config['config']

        Trello.configure do |trello_config|
          trello_config.developer_public_key = authentication['developer_public_key']
          trello_config.member_token = authentication['member_token']
        end

        @user = Trello::Member.find pello_config['username']
        @board_url = pello_config['board_url']
        @list_name = pello_config['list_name']
        @log_file  = pello_config['log_file']
      end
  end
end
