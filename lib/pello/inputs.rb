module Pello
  class Inputs
    def self.choose_card(list)
      card_names = list.cards.map(&:name)
      options = %w[a s d f g h j k l q w e r t y u i o p]
      menu = card_names.map { |card_name| [options[card_names.index(card_name)], card_name] }.to_h

      menu.each do |key, value|
        puts "#{key}) #{value}"
      end

      Choice.new(valid_options: options, message: '(choose card)').run(
        ->(input) { return Pello::Card.new(list.cards.detect { |c| c.name == menu[input] }) },
        lambda do
          puts 'Invalid option, try again...'
          return choose_card(list)
        end
      )
    end

    def self.choose_list(user, board_url, list_name)
      board = user.boards.detect { |b| b.url == board_url }
      board.lists.detect { |l| l.name == list_name }
    end
  end
end
