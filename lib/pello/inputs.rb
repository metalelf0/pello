require "tty-prompt"

module Pello
  class Inputs
    BACK_OPTION = '------ BACK ------'.freeze

    def self.choose_board(user, board_url)
      prompt = TTY::Prompt.new
      board_names = user.boards.map(&:name)
      default_board = user.boards.select { |b| b.url == board_url }.first.try(:name)
      board_names << BACK_OPTION
      input = prompt.select('Choose board', board_names, per_page: 15, default: default_board)
      return nil if input == BACK_OPTION

      Pello::Board.new(user.boards.detect { |b| b.name == input })
    end

    def self.choose_list(board, list_name)
      prompt = TTY::Prompt.new
      list_names = board.lists.map(&:name)
      list_names << BACK_OPTION
      default_list = board.lists.select { |l| l.name == list_name }.first.try(:name)
      input = prompt.select('Choose list', list_names, per_page: 15, default: default_list)
      return nil if input == BACK_OPTION

      Pello::List.new(board.lists.detect { |l| l.name == input })
    end

    def self.choose_card(list)
      prompt = TTY::Prompt.new
      card_names = list.cards.map(&:name)
      card_names << BACK_OPTION
      input = prompt.select('Choose card', card_names, per_page: 15)
      return nil if input == BACK_OPTION

      Pello::Card.new(list.cards.detect { |c| c.name == input })
    end
  end
end
