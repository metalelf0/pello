# frozen_string_literal: true

module Pello
  module Actions
    class DailyLog
      def run(user, board_url, date = Date.today)
        board = Pello::Inputs.choose_board user, board_url
        return unless board

        action_filters = [
          {
            name: 'Created cards',
            scope: ->(action, filter_date) { action.type == 'createCard' && action.date.to_date == filter_date },
            present: ->(action) { [action.data.dig(:card, :name), "[#{action.date}]"].join(' ') }
          },
          {
            name: 'Updated cards',
            scope: lambda { |action, filter_date|
                     %w[updateCard
                        updateCheckItemStateOnCard].include?(action.type) && action.date.to_date == filter_date
                   },
            present: ->(action) { [action.data.dig(:card, :name), "[#{action.date}]"].join(' ') }
          },
          {
            name: 'Commented cards',
            scope: ->(action, filter_date) { action.type == 'commentCard' && action.date.to_date == filter_date },
            present: lambda { |action|
                       [action.data.dig(:card, :name), '>', action.data[:text], "[#{action.date}]"].join(' ')
                     }
          }
        ]

        action_filters.each do |filter|
          actions = user.actions.select { |action| filter[:scope].call(action, date) }
          next unless actions.any?

          puts filter[:name]
          puts '------------------'
          actions.each do |action|
            puts filter[:present].call(action)
          end
          puts
        end
      end
    end
  end
end
