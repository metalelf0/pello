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
      board = user.boards.detect { |b| b.url == board_url }
      board.lists.detect { |l| l.name == list_name }
    end
  end
end
