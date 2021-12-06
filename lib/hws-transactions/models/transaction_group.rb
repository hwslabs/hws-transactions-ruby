# frozen_string_literal: true

require 'hws-transactions/models/base'
require 'hws-transactions/helpers/query'

module Hws::Transactions::Models
  class TransactionGroup < Base
    has_many :transaction_entries, foreign_key: 'transaction_group_id'

    DEFAULT_LIMIT = 10

    # tags: hash of the form mentioned below.
    # {
    #   'mutable_tags': {mutable_tag_key1: m_tag_val1, mutable_tag_key2: m_tag_val2},
    #   'immutable_tags': {immutable_tag_key1: i_tag_val1, immutable_tag_key2: i_tag_val2}
    # }
    def add_entry(value, txn_time, tags = {})
      tags = validate_and_sanitize_tags(tags)

      self.transaction_entries.create(
        value: value,
        txn_time: txn_time,
        mutable_tags: tags['mutable_tags'],
        immutable_tags: tags['immutable_tags']
      )
    end

    # only mutable tags are allowed to be updated
    # TODO: Optimistic locking?
    def update_entry(entry_id, mutable_tags)
      entry = self.transaction_entries.find(entry_id)

      unless mutable_tags.keys.all? { |key| self.mutable_tags.include?(key) }
        raise 'Invalid mutable tags present in update_entry request.'
      end

      entry.update!(mutable_tags: entry.mutable_tags.merge(mutable_tags))
    end

    # filters struture:
    # {
    #   'col1' => 'val1',
    #   'col2' => 'val2',
    #   'mut1' => {
    #     'jsonf1' => 'val1',
    #     'jsonf2' => {'nested_jsonf3' => 'val2'}
    #   }
    # }
    # pagination_context structure:
    # {
    #   'last_entry': '',
    #   'page_size': 10
    # }
    def list_entries(filters = {}, page_context = {})
      filtered_query = if filters.empty?
                         self.transaction_entries
                       else
                         Hws::Helpers::Query.construct_query(self.transaction_entries, filters)
                       end

      unless page_context['last_entry'].nil?
        filtered_query = filtered_query.where('id > ?', page_context['last_entry'])
      end
      filtered_query.order('id').limit(page_context['page_size'] || DEFAULT_LIMIT)
    end

    def mutable_tags
      @m_tags ||= self.tags['mutable_tags'].to_set
      @m_tags
    end

    def immutable_tags
      @i_tags ||= self.tags['immutable_tags'].to_set
      @i_tags
    end

    private

    def validate_and_sanitize_tags(tags)
      tags['mutable_tags'] = {} unless tags.key? 'mutable_tags'
      tags['immutable_tags'] = {} unless tags.key? 'immutable_tags'

      unless tags['mutable_tags'].keys.all? { |key| self.mutable_tags.include?(key) }
        raise "Invalid mutable tags present in add_entry request. Given keys: #{tags['mutable_tags'].keys} | Allowed keys: #{self.mutable_tags}"
      end

      unless tags['immutable_tags'].keys.all? { |key| self.immutable_tags.include?(key) }
        raise "Invalid immutable_tags tags present in add_entry request. Given keys: #{tags['immutable_tags'].keys} | Allowed keys: #{self.immutable_tags}"
      end

      tags
    end
  end
end
