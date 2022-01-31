# frozen_string_literal: true

module Pello
  module Actions
    class Report
      POMODORI_ADDED_COMMENT = /\((\d+) -> (\d+)\)$/.freeze

      def run(user, board_url)
        board = Pello::Inputs.choose_board user, board_url
        return unless board

        board_totals = {}

        lists = board.lists
        lists.each do |list|
          list_totals = {}
          list.cards.each do |card|
            card.comments.select { |comment| pello_log?(comment) }.each do |comment|
              lines_with_pomodori_increases_in(comment).each do |line|
                author_name = cached_author_name(comment.creator_id)
                pom_before, pom_after = pomodori_before_and_after_from(line)
                update_counters(list_totals, author_name, (pom_after - pom_before))
                update_counters(board_totals, author_name, (pom_after - pom_before))
              end
            end
          end

          print_counters(list_totals, list.name) if list_totals.any?
        end

        print_counters(board_totals, 'Totals')
        puts "\n"
      end

      def pomodori_before_and_after_from(comment_line)
        comment_line.match(POMODORI_ADDED_COMMENT)[1, 2].map(&:to_i)
      end

      def lines_with_pomodori_increases_in(comment)
        comment.data['text'].split("\n").select { |line| line.match? POMODORI_ADDED_COMMENT }
      end

      def pello_log?(comment)
        comment.data['text'] =~ /PELLO LOG/
      end

      def update_counters(counters, author_name, amount_to_add)
        counters[author_name] ||= 0
        counters[author_name] = counters[author_name] + amount_to_add
      end

      def print_counters(counters, label)
        puts "\n-- #{label}:"
        counters.each { |author_name, author_total| puts "* #{author_name}: #{author_total}" }
      end

      def cached_author_name(author_id)
        @author_names ||= {}
        @author_names[author_id] ||= Trello::Member.find(author_id).full_name
        @author_names[author_id]
      end
    end
  end
end
