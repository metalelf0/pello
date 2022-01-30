require 'forwardable'
require 'byebug'

module Pello
  class Card
    extend Forwardable

    NAME_REGEX = /(\(([0-9.]*)\))*\s*([0-9.]*)\s*🍅*\s*(.*)/.freeze
    attr_accessor :trello_card
    def_delegators :@trello_card, :name, :name=, :comments, :add_comment, :save, :id, :list_id, :list_id=

    def initialize(trello_card)
      @trello_card = trello_card
    end

    def extract_pomodori
      pomos = name.match(NAME_REGEX)[3]
      pomos ||= 0
      pomos.to_i
    end

    def extract_name
      name.match(NAME_REGEX)[-1]
    end

    def extract_points
      points = name.match(NAME_REGEX)[2]
      points ||= 0
      points.to_f
    end

    def log(event, user)
      comment = comments.select { |c| c.creator_id == user.id && c.data['text'] =~ /PELLO LOG/ }.first
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
