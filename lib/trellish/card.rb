require 'trellish/git'

module Trellish
  class Card
    include Trello
    include Trellish::Git

    def initialize(card_id_or_url)
      @member = Trellish::Auth.authorize
      @card = Trello::Card.find(parse_card_id(card_id_or_url))
    end

    def add_pull_request_link
      @card.description = "[Pull Request] (#{github_pull_request_url})\n\n#{@card.description}"
      @card.save
    end

    def finish
      add_pull_request_link
      remove_all
      move_to_qa
    end

    def move_to_qa
      qa_list = @card.board.lists.find { |list| list.name == Trellish.config[:qa_list_name] }
      if qa_list
        @card.move_to_list(qa_list)
      else
        Trellish.logger.warn "Unable to move card to #{Trellish.config[:qa_list_name]} list. No list named #{Trellish.config[:qa_list_name]} found."
      end
    end

    def remove_all
      @card.remove_all_members
    end

    private

    def parse_card_id(card_id_or_url)
      card_id_or_url.match(/[A-Za-z0-9]*$/)[0]
    end

  end
end
