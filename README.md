# Pello

Pello is a command line utility to perform Trello related tasks directly from your console.
Right now, it only allows adding pomodori to a Trello card. But stay tuned.

## Installation

First, run `gem install pello`.

Then, create the file `~/.config/pello/pello.yaml` with the following content:

```
auth:
  developer_public_key: ""
  member_token: ""
config:
  board_url: ""
  username: ""
  list_name: "In progress"
  log_file: "/Users/your_name/.pello_log"
```

Visit trello, get dev key and member token, etc.

## Usage

Run `pello` and follow the instructions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pello. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pello/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pello project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pello/blob/master/CODE_OF_CONDUCT.md).
