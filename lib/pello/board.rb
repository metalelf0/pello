require 'forwardable'
require 'tty/table'
require 'yaml'

module Pello
  class Board
    extend Forwardable
    attr_accessor :trello_board
    def_delegators :@trello_board, :cards, :lists

    def initialize(trello_board)
      @trello_board = trello_board
    end

    def as_table
      headers = trello_board.lists.map(&:name)
      cards = trello_board.lists.map { |list| list.cards.map { |card| truncate(card.name, 45) } }

      max_cards = cards.map(&:length).max
      cards = cards.map { |list_cards| list_cards + [nil] * (max_cards - list_cards.length) }

      tableized_cards = cards.transpose

      puts tableized_cards.to_yaml

      table = TTY::Table.new headers, tableized_cards
      table.render :unicode, multiline: true, resize: true, padding: [0, 0, 1, 0]
    end

    private

    def truncate(string, truncate_at, options = {})
      return string.dup unless string.length > truncate_at

      omission = options[:omission] || '...'
      length_with_room_for_omission = truncate_at - omission.length
      stop = if options[:separator]
               rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
             else
               length_with_room_for_omission
             end

      "#{string[0, stop]}#{omission}"
    end
  end
end
