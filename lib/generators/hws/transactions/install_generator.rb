# frozen_string_literal: true

require 'rails/generators/migration'
require 'rails/generators/active_record'

module Hws
  module Transactions # :nodoc:
    module Generators # :nodoc:
      class InstallGenerator < ::Rails::Generators::Base # :nodoc:
        include Rails::Generators::Migration
        source_root File.expand_path('templates', __dir__)

        def self.next_migration_number(path)
          ActiveRecord::Generators::Base.next_migration_number(path)
        end

        desc 'copying migrations to db/migrate'
        def copy_migrations
          migration_template 'create_transaction_group_and_entries.rb.erb',
                             'db/migrate/create_hws_transaction_tables.rb'
        end
      end
    end
  end
end
