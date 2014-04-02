# Dabster

Dabster is a digital music metadata management tool.  It is not intended to address basic cataloging and tagging of files but rather it serves as a framework for gathering, storing, organizing, and using extended metadata information.  It is designed to read albums/songs from the database created and managed by [beets](http://beets.radbox.org/).  Dabster creates its own database to store additional information and references items in the beets database. At a high level the goal of Dabster is to go beyond typical artist/album/song breakdowns when interfacing with music in a collection.

Some types of extended metatdata Dabster may be concerned with:
* Song/artist tags and counts
* Artist relationships (similarity, etc.)
* Song/artist/album identifiers from other, existing databases
* Cultural or social perspective on a song/artist/album
* Quantitative information about songs such as tempo and liveliness
* Existing playlists containing your music

Along with caching and associating metatdata, Dabster also serves to make use of the information. Future ideas include:
* Experimentation with recommendation and playlist generation algorithms (Pandora with your own music collection)
* A tag filtering and normalization engine (expand beyond a single genre tag per album)
* Suggest music to add to your collection or even add it automatically
* Provide playback through different methods
* Writing to media file tags

An important goal is to make Dabster modular and easily extensible so that components for different metadata sources and consumers can be integrated easily.

Dabster is under development and experimental.  Currently, Dabster can cache and associate album, artist, and similar artist information from what.cd with album and song entries created by beets.

## Installation

Dabster provides both a command line and web interface.

To access the web interface, first create a host Rails app:

```$ rails new app```

Add this line to your application's Gemfile:

```gem 'dabster', git: 'git://github.com/jlefley/dabster.git'```

Then execute:

```$ bundle```

Add this line to `config/routes.rb`:

``` mount Dabster::Engine => '/'```

Dabster stores its database by default in `~/.config/dabster` so it can be easily accessed by the command line interface.  This should be the same database used by the Rails app. Edit `config/database.yml` so both the web app and the command line interface will use the same database:

```
development:
  adapter: sqlite3
  database: ~/.config/dabster/dabster.sqlite3
```

Dabster will always ensure the database is loaded with the schema and required seed data when starting.

Dabster uses a config file at `~/.config/dabster/config.yml`.  Here are the options with their default values:

```
library_database: ~/.config/beets/library.db  (path to the SQLite database used by beets)
database: ~/.config/dabster/dabster.sqlite3   (path to the SQLite database used by Dabster)
log: ~/.config/dabster/dabster.log            (path to log file used by Dabster)
whatcd_username: ''                           (what.cd username for API access)
whatcd_password: ''                           (what.cd password for API access)
```

It is recommended that at least the what.cd login info and library_database options are set.  Dabster will not work unless it is pointed to an existing beets database through the library_database config option.

## Usage

Start the Rails server:

```$ rails s```

Go to `localhost:3000` and browse through various lists by selecting a link at the top of the layout. Library Albums will list all the albums in the beets database.  Select an album to inspect it. Click the search what.cd button to look for a torrent group matching the album.  Select a matching result and click associate.  Now the items for that album are associated with the matching what.cd artist(s) and the album is associated with the torrent group.  A torrent group id can be used directly instead of searching and making a selection.

To attempt to associate all albums in the beets database with corresponding what.cd entries, execute this command:

```$ dabster match```

Several attempts will be made to locate the correct group for each album using artist/album information. The album will be left unassociated if a likely match is not found.

Similar artist information can also be loaded with the following command:

```$ dabster update similarartists```

This will create relationships between any artists that are already in the database and also are considered similar on what.cd.

The web interface can be used to manually update the associations and locate and remove rouge entries.

## Next Steps

* Implement rudimentary playlist generation and playback through XMMS2
* Fetch data from EchoNest, Discogs and Last.fm
* Normalize and associate tags (like [whatlastgenre](https://github.com/YetAnotherNerd/whatlastgenre))

## Contributing

1. Fork it ( http://github.com/jlefley/dabster/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
