require 'trellish/git'

module Trellish
  class Card
    include Trello
    include Trellish::Git

    def initialize(card_id_or_url)
      @member = Trellish::Auth.authorize
      @card = Trello::Card.find(parse_card_id(card_id_or_url))
    end

    def add_branch_link
      @card.add_comment(github_branch_url)
    end

    def add_merge_to_master_item
      checklist = @card.checklists.first
      if checklist.nil?
        new_checklist = Checklist.create(name: 'Checklist', board_id: @card.board_id)
        @card.add_checklist(new_checklist)
        checklist = @card.refresh!.checklists.first
      end
      checklist.add_item('Merge to master')
    end

    def finish
      add_branch_link
      add_merge_to_master_item
      remove_me
      move_to_qa
    end

    def move_to_qa
      qa_list = @card.board.lists.find { |list| list.name == 'QA' }
      if qa_list
        @card.move_to_list(qa_list)
      else
        Trellish.logger.warn "Unable to move card to 'QA' list. No list named 'QA' found."
      end
    end

    def remove_me
      if @card.members.include? @member
        @card.remove_member(@member) rescue nil
      end
    end

    private

    def parse_card_id(card_id_or_url)
      card_id_or_url.match(/[A-Za-z0-9]*$/)[0]
    end

  end
end
