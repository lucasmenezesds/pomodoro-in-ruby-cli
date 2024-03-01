# PiRb-CLI

Pomodoro in Ruby - CLI version

A simple pomodoro developed using ruby.

## Installation

1. Run $ `bundle install`

2. Add the `.wav` file you would like to use as notification sound inside the folder `media`.
    1. In case you want only one notification sound:
        - Add a file named `notification.wav`
    2. In case you want a different notification sound for focus and rest.
        - Add a file named `focus_notification.wav`
        - Add a file named `rest_notification.wav`

<br>

**NOTE:** If you prefer to not have any sound played when the timer is over you can leave the media folder empty. The
pomodoro will work normally.

#### Ubuntu Based

If you're using Ubuntu based distro you'll need to install `libgtk2.0-dev` in order to run the project

#### Other OS

Due the usage of the gem FFI you'll probably have a problem this missing files `libgobject-2.0.so`, so you'll need to
install the respective library that will provide it. Probably installing a `gtk` lib should be enough to run the project

NOTE: Windows OS is not supported.

## Usage

- Starting the Pomodoro:
    - `bin/pomodoro` or `ruby bin/pomodoro`


- To cancel/quit the pomodoro in the middle:
    - `CTRL + C`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasmenezesds/pomodoro-in-ruby-cli. This
project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/lucasmenezesds/pomodoro-in-ruby-cli/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PiRb-CLI project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/lucasmenezesds/pomodoro-in-ruby-cli/blob/master/CODE_OF_CONDUCT.md).
