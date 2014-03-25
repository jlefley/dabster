# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Sequel::Model.db[:whatcd_release_types].multi_insert([
  { id: 1, name: 'Album' },
  { id: 3, name: 'Soundtrack' },
  { id: 5, name: 'EP' },
  { id: 6, name: 'Anthology' },
  { id: 7, name: 'Compilation' },
  { id: 8, name: 'DJ Mix' },
  { id: 9, name: 'Single' },
  { id: 11, name: 'Live album' },
  { id: 13, name: 'Remix' },
  { id: 14, name: 'Bootleg' },
  { id: 15, name: 'Interview' },
  { id: 16, name: 'Mixtape' },
  { id: 21, name: 'Unknown' },
  { id: 22, name: 'Concert Recording' },
  { id: 23, name: 'Demo' }
])
