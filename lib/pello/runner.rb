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
          menu.choice name: 'Move card', value: :move_card
          menu.choice name: 'Print board pomodori report', value: :report
          menu.choice name: 'Edit config', value: :edit_config
          menu.choice name: 'quit', value: :quit
        end
        when :add_pomodori
          add_pomodori_to_card
        when :move_card
          move_card
        when :report
          report
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
      Pello::Actions::AddPomodoriToCard.new(prompt).run(@user, board_url, list_name)
    end

    def move_card
      Pello::Actions::MoveCard.new(prompt).run(@user, board_url, list_name)
    end

    def report
      Pello::Actions::Report.new.run(@user, board_url)
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
