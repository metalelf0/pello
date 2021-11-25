require 'forwardable'
require 'byebug'

module Pello
  class Card
    extend Forwardable

    TITLE_REGEX = /(\(([0-9.]*)\))*\s*([0-9.]*)\s*🍅*\s*(.*)/.freeze
    attr_accessor :trello_card
    def_delegators :@trello_card, :name, :name=, :comments, :add_comment, :save, :id

    def initialize(trello_card)
      @trello_card = trello_card
    end

    def extract_pomodori
      pomos = name.match(TITLE_REGEX)[3]
      pomos ||= 0
      pomos.to_i
    end

    def extract_title
      name.match(TITLE_REGEX)[-1]
    end

    def extract_points
      points = name.match(TITLE_REGEX)[2]
      points ||= 0
      points.to_f
    end

    def title_with_added_pomodori(how_many = 1)
      current_pomodori = extract_pomodori
      current_points = extract_points
      current_title = extract_title
      result = []
      result << "(#{current_points})" unless current_points.zero?
      result << "#{current_pomodori + how_many} 🍅"
      result << current_title
      result.join(' ')
    end

    def log(event)
      comment = comments.select { |c| c.data['text'] =~ /PELLO LOG/ }.first
      if comment
        new_text = [comment.data['text'], event].join("\n")
        comment.delete
        add_comment new_text
      else
        text = ['~~~PELLO LOG', event].join("\n")
        add_comment text
      end
    end
  end
end
