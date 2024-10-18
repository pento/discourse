# frozen_string_literal: true

module Migrations::CLI
  module SchemaCommand
    def self.included(thor)
      thor.class_eval do
        desc "schema [COMMAND]", "Manage database schema"
        subcommand "schema", SchemaSubCommand
      end
    end

    class SchemaSubCommand < Thor
      desc "generate", "Generates the database schema"
      method_option :db, type: :string, default: "intermediate_db", desc: "Name of the database"
      def generate
        db = options[:db]

        config_path = File.join(::Migrations.root_path, "config", "#{db}.yml")
        if !File.exist?(config_path)
          $stderr.puts "Configuration file for #{db} wasn't found at '#{config_path}'"
          exit 1
        end

        puts "Loading schema for #{db.bold}..."
        ::Migrations.load_rails_environment(quiet: true)
        config = YAML.load_file(config_path, symbolize_names: true)
        loader = ::Migrations::Database::Schema::Loader.new(config[:schema])
        schema = loader.load_schema

        if loader.errors.present?
          loader.errors.each { |error| $stderr.puts "ERROR: ".red << error }
          exit 2
        end

        writer = ::Migrations::Database::Schema::TableWriter.new($stdout)
        schema.each { |table| writer.output_table(table) }
      end
    end
  end
end
