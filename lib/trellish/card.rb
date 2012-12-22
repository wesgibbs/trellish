require 'trellish/git'

module Trellish
  class Card
    include Trello
    include Trellish::Git

    def self.select_from_list(list_name, assigned_to_me = false)
      me = Trellish::Auth.authorize
      boards = me.boards(filter: :open)
      current_board = boards.find { |board| board.name == Trellish.config[:board_name] }

      list = current_board.lists.find { |list| list.name == list_name }
      cards = list.cards

      if assigned_to_me
        cards = cards.find_all { |card| card.member_ids.include?(me.id) }
      end

      case cards.length
      when 0
        if assigned_to_me
          Trellish.logger.error "There are no cards assigned to you in the list `#{list_name}`"
        else
          Trellish.logger.error "There are no cards in the list `#{list_name}`"
        end
        exit
      when 1
        index = 0
      else
        puts "\nSelect a card:"
        cards.each_with_index { |card, index| puts "#{index+1}. #{card.name}" }
        index = Readline.readline("> ")
        exit if index.blank?
        index = index.to_i - 1
      end

      Trellish::Card.new( cards[index].id )
    end

    def initialize(card_id_or_url)
      @member = Trellish::Auth.authorize
      @card = Trello::Card.find(parse_card_id(card_id_or_url))
    end

    def add_me_as_member
      @card.add_member(@member) unless @card.member_ids.include?(@member.id)
    end

    def add_pull_request_link
      @card.description = "[Pull Request](#{github_pull_request_url})\n\n#{@card.description}"
      @card.save
    end

    def create_local_branch
      branch_name = "#{git_user_initials}-#{short_name}"
      git_create_local_branch(branch_name)
    end

    def finish
      add_pull_request_link
      remove_all
      move_to_qa
    end

    def move_to_qa
      move_to_list(Trellish.config[:qa_list_name])
    end

    def move_to_in_progress
      move_to_list(Trellish.config[:in_progress_list_name])
    end

    def name
      @card.name
    end

    def remove_all
      @card.remove_all_members
    end

    def short_name
      name.strip.downcase.tr(' ','-').gsub(/[^0-9A-Za-z\-]/, '')[0..30]
    end

    def start
      move_to_in_progress
      add_me_as_member
      create_local_branch
    end

    private

    def move_to_list(list_name)
      list = @card.board.lists.find { |list| list.name == list_name }
      if list
        @card.move_to_list(list)
      else
        Trellish.logger.warn "Unable to move card to #{list_name} list. No list named #{list_name} found."
      end
    end

    def parse_card_id(card_id_or_url)
      card_id_or_url.match(/[A-Za-z0-9]*$/)[0]
    end

  end
end
