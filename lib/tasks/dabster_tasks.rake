require 'sequel_rails/storage'

namespace :dabster do
  namespace :db do
    desc 'Load the Dabster schema structure file into the current env database'
    task :load_structure, [:env] => :environment do |t, args|
      args.with_defaults(env: Rails.env)

      filename = File.join(Dabster::Engine.root, 'db', 'structure.sql')

      unless SequelRails::Storage.load_environment args.env, filename
        abort "Could not load structure for #{args.env}."
      end

    end
  end
end
