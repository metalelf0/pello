require 'forwardable'
require 'tty/table'

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
      cards = trello_board.lists.map { |list| list.cards.map(&:name) }

      max_cards = cards.map(&:length).max
      cards = cards.map { |list_cards| list_cards + [nil] * (max_cards - list_cards.length)}

      tableized_cards = cards.transpose

      table =  TTY::Table.new headers, tableized_cards
      table.render :unicode, multiline: true, resize: true, padding: [0, 0, 1, 0]
    end
  end
end
