require 'tinder'

module Trellish
  module Campfire

    def announce(message)
      room.speak message if room
    end

    private

    def room
      @room ||=
        if [:campfire_subdomain, :campfire_token, :campfire_room].all? { |s| Trellish.config[s] }
          campfire = Tinder::Campfire.new Trellish.config[:campfire_subdomain], :token => Trellish.config[:campfire_token]
          campfire.rooms.find { |room| room.name == Trellish.config[:campfire_room] }
        end
    rescue
      Trellish.logger.error "Unable to access Campfire. Is your subdomain, token, and room name correct?"
      exit
    end

  end
end
