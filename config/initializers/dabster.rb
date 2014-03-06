library_db = '/home/jlefley/development/music/dabster/musiclibrary.db'

Sequel::Model.db.run("ATTACH DATABASE '#{library_db}' AS libdb")
