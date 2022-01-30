module Pello
  class CardLogger
    def log(user, card, event)
      comment = card.comments.select { |c| c.creator_id == user.id && c.data['text'] =~ /PELLO LOG/ }.first
      if comment
        text = [comment.data['text'], event].join("\n")
        comment.delete
      else
        text = ['~~~PELLO LOG', event].join("\n")
      end
      card.add_comment text
    end
  end
end
