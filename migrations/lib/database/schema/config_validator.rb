# frozen_string_literal: true

module Migrations::Database::Schema
  class ConfigValidator
    def initialize
      @db = ActiveRecord::Base.connection
      @errors = []
    end

    def validate(config)
      @errors.clear

      check_required_keys
    end

    private

    def check_required_keys(config)
      @errors << "`output_file_path` is missing" unless config.key?(:output_file_path)

      if !config.key?(:schema)
        @errors << "`schema` is missing"
        return
      end

      schema_config = config[:schema]
      @errors << "`schema.tables` is missing" unless schema_config.key?(:tables)
      @errors << "`schema.global` is missing" unless schema_config.key?(:global)
    end
  end
end
