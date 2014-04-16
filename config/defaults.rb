%w(test development production).each do |env|
  Configuration.for(env) {
    whatcd {
      username ''
      password ''
    }  
  }
end

Configuration.for('test') {
  database         ':memory:'
  log              "#{Dir.home}/.config/dabster/test.log"
  library_database ':memory:'
}

Configuration.for('development') {
  database         "#{Dir.home}/.config/dabster/development.sqlite3"
  log              "#{Dir.home}/.config/dabster/development.log"
  library_database "#{Dir.home}/.config/beets/library.db"
}

Configuration.for('production') {
  database         "#{Dir.home}/.config/dabster/production.sqlite3"
  log              "#{Dir.home}/.config/dabster/production.log"
  library_database "#{Dir.home}/.config/beets/library.db"
}
