# frozen_string_literal: true

module Pello
  module Actions
    class AddPomodoriToCard
      attr_reader :prompt

      def initialize(prompt)
        @prompt = prompt
      end

      def run(user, board_url, list_name)
        board = Pello::Inputs.choose_board user, board_url
        return unless board

        puts board.as_table
        continue = true
        while continue
          list = Pello::Inputs.choose_list board, list_name
          return unless list

          card = Pello::Inputs.choose_card list
          next unless card

          pomodori_before = card.extract_pomodori
          pomodori_to_add = prompt.ask('Pomodori', default: 1)

          new_name = name_with_added_pomodori(card, pomodori_to_add.to_i)

          puts "Updating card #{card.name}"
          puts "New title:    #{new_name}"

          if prompt.yes?('Confirm?')
            card.name = new_name
            card.save
            card.log "[#{Time.now}] #{card.extract_name} (#{pomodori_before} -> #{card.extract_pomodori})", user
            puts('Done!')
          else
            puts 'Ok, bye!'
            nil
          end

          continue = prompt.yes?('Another one?')
        end
      end

      private

      def name_with_added_pomodori(card, pomodori_to_add)
        current_pomodori = card.extract_pomodori
        current_points = card.extract_points
        current_name = card.extract_name

        result = []
        result << "(#{current_points})" unless current_points.zero?
        result << "#{current_pomodori + pomodori_to_add} 🍅"
        result << current_name
        result.join(' ')
      end
    end
  end
end
