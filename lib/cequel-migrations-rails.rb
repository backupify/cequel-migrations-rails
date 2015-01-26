require "cassandra-cql"

require "cequel-migrations-rails/version"
require "cequel-migrations-rails/keyspace_manager"
require "cequel_cql2/migration"

module CequelCQL2
  module Migrations
    module Rails
      class Railtie < ::Rails::Railtie
        rake_tasks do
          load "cequel-migrations-rails/tasks/migrations.rake"
        end
      end
    end
  end
end
