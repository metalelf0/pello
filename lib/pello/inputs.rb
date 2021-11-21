require "tty-prompt"

module Pello
  class Inputs
    def self.choose_card(list)
      prompt = TTY::Prompt.new
      card_names = list.cards.map(&:name)
      input = prompt.enum_select('Choose card', card_names, per_page: 10)
      Pello::Card.new(list.cards.detect { |c| c.name == input })
    end

    def self.choose_list(user, board_url, list_name)
      prompt = TTY::Prompt.new
      board = user.boards.detect { |b| b.url == board_url }
      puts Pello::Board.new(board).as_table
      list_names = board.lists.map(&:name)
      input = prompt.enum_select('Choose list', list_names, per_page: 10, default: list_name)
      Pello::List.new(board.lists.detect { |l| l.name == input })
    end
  end
end
