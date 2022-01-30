# frozen_string_literal: true

require 'yaml'
require 'trello'
require 'tty-prompt'

Trello::Comment.send(:define_method, :action_id) do
  id
end

module Pello
  class Runner
    attr_accessor :board_url, :list_name, :log_file_path, :prompt, :username

    def initialize
      @prompt = TTY::Prompt.new
      configure_pello
    end

    def run!
      continue = true

      while continue
        case prompt.select('Choose task') do |menu|
          menu.choice name: 'Add pomodori', value: :add_pomodori
          menu.choice name: 'Edit config', value: :edit_config
          menu.choice name: 'quit', value: :quit
        end
        when :add_pomodori
          add_pomodori_to_card
        when :edit_config
          editor = ENV['EDITOR'] || 'vim'
          system 'mkdir -p ~/.config/pello'
          system "#{editor} ~/.config/pello/pello.yaml"
        when :quit
          puts 'Ok, bye!'
          exit
        end
      end
    end

    private

    def add_pomodori_to_card
      board = Pello::Inputs.choose_board @user, @board_url
      return unless board

      puts board.as_table
      continue = true
      while continue
        list = Pello::Inputs.choose_list board, @list_name
        return unless list

        card = Pello::Inputs.choose_card list
        next unless card

        pomodori_before = card.extract_pomodori
        pomodori_to_add = prompt.ask('Pomodori', default: 1)

        puts "Updating card #{card.name}"
        puts "New title:    #{card.name_with_added_pomodori(pomodori_to_add.to_i)}"

        if prompt.yes?('Confirm?')
          card.name = card.name_with_added_pomodori(pomodori_to_add.to_i)
          card.save
          card.log "[#{Time.now} - #{@user.full_name}] #{card.extract_name} (#{pomodori_before} -> #{card.extract_pomodori})", @user
          puts('Done!')
        else
          puts 'Ok, bye!'
          nil
        end

        continue = prompt.yes?('Another one?')
      end
    end

    def configure_pello
      config = Pello::Config.new
      if config.valid?
        Trello.configure do |trello_config|
          trello_config.developer_public_key = config.developer_public_key
          trello_config.member_token = config.member_token
        end

        @user          = Trello::Member.find config.username
        @board_url     = config.board_url
        @list_name     = config.list_name
      else
        puts 'No config found, opening config file...'
        Pello::Config.write_empty_config
        system "#{ENV['EDITOR']} #{Pello::Config::CONFIG_FILE_PATH}"
        exit
      end
    end
  end
end
