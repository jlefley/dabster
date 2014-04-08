require 'sequel_rails/storage'
require 'fileutils'

Rake.application.instance_variable_get('@tasks').delete('dabster:install:migrations')

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

  namespace :install do
    desc 'Copy migrations from engine to host application'
    task migrations: :environment do
      src_path = File.join(Dabster::Engine.root, 'db', 'migrate')
      dest_path = File.join(Rails.root, 'db', 'migrate')
      src_migrations = Dir[File.join(src_path, '*.rb')].map { |p| File.basename(p) }
      dest_migrations = Dir[File.join(dest_path, '*.rb')].map { |p| File.basename(p) }
      (src_migrations - dest_migrations).each do |migration|
        src = File.join(src_path, migration)
        FileUtils.cp(src, dest_path) 
        puts "Copied #{src} to #{dest_path}"
      end
    end
  end
end
