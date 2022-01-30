# frozen_string_literal: true

module Pello
  module Actions
    class MoveCard
      attr_reader :prompt, :logger

      def initialize(prompt, logger = Pello::CardLogger.new)
        @prompt = prompt
        @logger = logger
      end

      def run(user, board_url, list_name)
        board = Pello::Inputs.choose_board user, board_url
        return unless board

        puts board.as_table
        continue = true
        while continue
          source_list = Pello::Inputs.choose_list board, list_name, 'Choose source list'
          return unless source_list

          card = Pello::Inputs.choose_card source_list
          next unless card

          target_list = Pello::Inputs.choose_list board, list_name, 'Choose target list'
          return unless target_list && target_list != source_list

          puts "Moving card #{card.name} from \"#{source_list.name}\" to \"#{target_list.name}\""

          if prompt.yes?('Confirm?')
            card.list_id = target_list.id
            card.save
            logger.log user, card, "[#{Time.now}] #{card.extract_name} (#{source_list.name} -> #{target_list.name})"
            puts('Done!')
          else
            puts 'Ok, bye!'
            nil
          end

          continue = prompt.yes?('Another one?')
        end
      end
    end
  end
end
