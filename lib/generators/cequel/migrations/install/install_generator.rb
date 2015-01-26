module CequelCQL2
  module Migrations
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc <<DESC
  Description:
      Setup cequel migrations directory structure.
DESC

        def self.source_root
          @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
        end

        def copy_schema_files
          directory 'cequel'
        end
      end
    end
  end
end
