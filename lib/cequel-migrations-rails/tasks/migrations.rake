require 'shearwater'
require 'shearwater/cassandra_cql_backend'

namespace :cequel do
  desc "Create the cequel specified cassandra keystore for the current environment"
  task :create => :environment do
    keyspace_manager = CequelCQL2::Migrations::Rails::KeyspaceManager.new
    keyspace_manager.create_keyspace
    keyspace_manager.use_keyspace
    keyspace_manager.db.execute("CREATE COLUMNFAMILY schema_migrations (version bigint PRIMARY KEY, migrated_at timestamp)")
  end

  desc "Drop the cequel specified cassandra keystore for the current environment"
  task :drop => :environment do
    keyspace_manager = CequelCQL2::Migrations::Rails::KeyspaceManager.new
    keyspace_manager.drop_keyspace
  end

  desc "Migrate the cassandra store"
  task :migrate => :environment do
    keyspace_manager = CequelCQL2::Migrations::Rails::KeyspaceManager.new
    keyspace_manager.use_keyspace

    # Create the migrator
    backend = Shearwater::CassandraCqlBackend.new(keyspace_manager.db)
    migrations_directory = ::Rails.root.join('cequel', 'migrate')
    migrator = Shearwater::Migrator.new(migrations_directory, backend)

    # Migrate
    migrator.migrate
  end

  desc "Rollback to the previous migration version by 1 step"
  task :rollback => :environment do
    keyspace_manager = CequelCQL2::Migrations::Rails::KeyspaceManager.new
    keyspace_manager.use_keyspace

    # Create the migrator
    backend = Shearwater::CassandraCqlBackend.new(keyspace_manager.db)
    migrations_directory = ::Rails.root.join('cequel', 'migrate')
    migrator = Shearwater::Migrator.new(migrations_directory, backend)

    steps = ENV['STEPS'] || 1

    # Migrate
    migrator.rollback(steps.to_i)
  end

  desc "Drop the keystore, recreate it and run the migrations"
  task :reset  do
    Rake::Task["cequel:drop"].invoke
    Rake::Task["cequel:create"].invoke
    Rake::Task["cequel:migrate"].invoke
  end

  desc "Launches cqlsh command and connects to cassandra server specified in your cequel.yml"
  task :shell do
    keyspace_manager = CequelCQL2::Migrations::Rails::KeyspaceManager.new
    server_parts = keyspace_manager.db.connection.current_server.to_s.split(':')
    server_ip = server_parts[0]
    server_port = server_parts[1]

    system("cqlsh -k #{CequelCQL2::Migrations::Rails::KeyspaceManager.cequel_env_conf['keyspace']} #{server_ip} #{server_port}")
  end
end
