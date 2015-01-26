module CequelCQL2
  module Generators
    class MigrationGenerator < ::Rails::Generators::NamedBase
      attr_reader :migration_class_name

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def create_migration
        @migration_class_name = file_name.camelize
        migration_timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        template 'migration.rb', File.join("cequel/migrate/#{migration_timestamp}_#{file_name.underscore}.rb")
      end
    end
  end
end
