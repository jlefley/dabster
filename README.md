# Dabster

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'dabster'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dabster

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dabster/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

XMMS2

  Need
    libasound2-dev
    libpulse-dev
    libmad0-dev
    libflac-dev
    libvorbis-dev
    
  ./waf configure \
    --with-plugins=alsa,pulse,file,flac,mad,mp4,id3v2,vorbis,wave \
    --with-optionals=launcher,nycli,ruby \
    --with-default-output-plugin=alsa \
    --with-ruby-binary=/usr/local/bin/ruby
