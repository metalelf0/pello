require "tty-prompt"

module Pello
  class Inputs
    BACK_OPTION = '< BACK'.freeze

    def self.choose_board(user, board_url)
      prompt = TTY::Prompt.new
      board_names = user.boards.map(&:name)
      default_board = user.boards.select { |b| b.url == board_url }.first.try(:name)
      board_names << BACK_OPTION
      input = prompt.enum_select('Choose board', board_names, per_page: 10, default: default_board)
      return nil if input == BACK_OPTION

      Pello::Board.new(user.boards.detect { |b| b.name == input })
    end

    def self.choose_list(board, list_name)
      prompt = TTY::Prompt.new
      list_names = board.lists.map(&:name)
      default_list = board.lists.select { |l| l.name == list_name }.first.try(:name)
      input = prompt.enum_select('Choose list', list_names, per_page: 10, default: default_list)
      Pello::List.new(board.lists.detect { |l| l.name == input })
    end

    def self.choose_card(list)
      prompt = TTY::Prompt.new
      card_names = list.cards.map(&:name)
      input = prompt.enum_select('Choose card', card_names, per_page: 10)
      Pello::Card.new(list.cards.detect { |c| c.name == input })
    end
  end
end
