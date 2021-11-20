module Pello
  class Choice
    attr_accessor :valid_options, :message

    def initialize(args = {})
      @valid_options = args[:valid_options]
      @message       = args[:message]
    end

    def run(success, failure)
      print "#{message} > "
      input = gets.chomp
      if valid_options.include?(input)
        success.call(input)
      else
        failure.call
      end
    end
  end
end

