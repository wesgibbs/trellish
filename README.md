# Trellish

Trellish is used to start and finish a Trello card. It does everything necessary to move a development card from "Next up" to "In Progress" when you start work on a card and again from "In Progress" to "QA" when you finish a card.

## Installation

Add this line to your application's Gemfile:

    gem 'trellish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trellish

## Setup

Create a `./trellish.yml`, `~/trellish.yml` or `~/.trellish` file. Set it up like this:

1. Sign in to Trello and go to https://trello.com/1/appKey/generate.
1. Copy "Key" from that page to trello\_api\_key.
1. Copy "Secret (for OAuth signing)" from that page to trello\_oauth\_secret.
1. Visit https://trello.com/1/authorize?key=TRELLO\_API\_KEY\_FROM\_ABOVE&name=Trellish&expiration=never&response_type=token&scope=read,write
1. Copy the token to trello\_oauth\_token.
1. Run: `curl -u 'username' -d '{"scopes":["repo"],"note":"Trellish"}' https://api.github.com/authorizations`
1. Copy the token parameter from the response to github\_oauth\_token.

Optionally, Trellish can announce the starting and finishing of cards on 37signal's [Campfire](http://campfirenow.com/). To enable this:

1. Sign in to Campfire and go to your "my info" page. You can find the link in the upper-right corner.
1. Copy your subdomain name to campfire\_subdomain.
1. Copy your API authentication token to campfire\_token.
1. Specify the room name in campfire\_room.

## Usage

By default, Trellish expects a Trello board named `Current` with 3 lists: `Next up`, `In progress`, and `QA`. You can change these defaults using the Trellish config file.

To start work on a card:

    trellish start [Trello card id or URL]

This will:

- move the card from `Next up` to `In progress`,
- add you as a member,
- create a local git branch named using your git initials and the card's title.

If you don't provide a card id or URL on the command line, trellish shows you the cards in `Next up` and prompts you to select one, like so:

    Select a card:
    1. BUG: crash adding a comment
    2. users can select an avatar
    3. add iPad integration tests
    >

When you're done working on a card, finish it using:

    trellish finish [Trello card id or URL]

Like:

    trellish finish https://trello.com/c/a3Wbcde4
    trellish finish a3Wbcde4
    trellish finish

This will:

- create a pull request to merge your topic branch into master (with a description linking back to the card)
- add a link to the pull request from the card's description
- remove everyone from the card
- move the card to the QA list

## Certificate issues

If you're stuck with an error along the lines of

    SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed

try updating your root certificates. If you use RVM, this may work:

    curl http://curl.haxx.se/ca/cacert.pem -o ~/.rvm/usr/ssl/cert.pem

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
