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

1. Sign in to Trello and go to https://trello.com/1/appKey/generate.
1. Copy "Key" from that page to tello\_api\_key.
1. Copy "Secret (for OAuth signing)" from that page to tello\_oauth\_secret.
1. Visit http://trello.com/1/connect?key=TRELLO\_API\_KEY\_FROM\_ABOVE&name=Trellish&response_type=token&scope=read,write&expiration=never
1. Copy the token to trello\_oauth\_token.
1. Run: `curl -u 'username' -d '{"scopes":["repo"],"note":"Trellish"}' https://api.github.com/authorizations`
1. Copy the token parameter from the response to github\_oauth\_token.

`git checkout` the topic branch for the card you are finishing. Then do this:

    trellish https://trello.com/c/a3Wbcde4

or alternately:

    trellish a3Wbcde4

This will:

- create a pull request to merge your topic branch into master
- add a link to the pull request to the beginning of the card description
- remove everyone from the card
- move the card to the QA list

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
