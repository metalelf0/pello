require 'forwardable'

module Pello
  class List
    extend Forwardable
    attr_accessor :trello_list
    def_delegators :@trello_list, :cards

    def initialize(trello_list)
      @trello_list = trello_list
    end
  end
end
