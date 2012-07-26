# Trellish

Trellish is used to finish a Trello card. It does everything necessary to move a development card from the In Progress list to the QA list.

## Installation

Add this line to your application's Gemfile:

    gem 'trellish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trellish

## Usage

Create a trellish.yml file in your current directory or home directory. Set it up like this:

    # Sign in to Trello and go here https://trello.com/1/appKey/generate.
    # Copy "Key" from that page to tello_api_key.
    trello_api_key: numbers_and_letters_and_stuff
    # Copy "Secret (for OAuth signing)" from that page to tello_oauth_secret.
    trello_oauth_secret: numbers_and_letters_and_stuff
    # Visit http://trello.com/1/connect?key=TRELLO_API_KEY_FROM_ABOVE&name=Trellish&response_type=token&scope=read,write&expiration=never and copy the token to trello_oauth_token.
    trello_oauth_token: numbers_and_letters_and_stuff

git checkout the topic branch for the card you are finishing. Then do this:

    trellish https://trello.com/c/a3Wbcde4

or alternately:

    trellish a3Wbcde4

This will:

- add a link to the branch on github as a comment on the card
- add a checklist named "Checklist" if one doesn't exist
- add an item to that checklist called "Merge to master"
- remove you from the card
- move the card to the QA list

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
