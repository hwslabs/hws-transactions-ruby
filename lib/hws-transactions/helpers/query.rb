# frozen_string_literal: true

module Hws::Helpers # :nodoc:
  class Query # :nodoc:
    class << self
      def construct_query(base, filter_hash)
        mut = filter_hash.key?('mutable_tags') ? filter_hash.delete('mutable_tags') : {}
        immut = filter_hash.key?('immutable_tags') ? filter_hash.delete('immutable_tags') : {}

        query = base.where(filter_hash)
        query = query_jsonb(query, 'mutable_tags', mut)
        query_jsonb(query, 'immutable_tags', immut)
      end

      def query_jsonb(base, column_name, filter_hash)
        return base if filter_hash.empty?

        base.where("#{column_name} @> ?", filter_hash.to_json)
      end
    end
  end
end
