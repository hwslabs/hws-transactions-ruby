# rubocop:disable Naming/FileName
# frozen_string_literal: true

module Hws # :nodoc:
  module Transactions
    # name: name of the journal
    # description: description of the journal
    # mutable_tags: []
    # immutable_tags: []
    def self.create_group(name, description, mutable_tags, immutable_tags)
      ::Hws::Transactions::Models::TransactionGroup.create(name: name, description: description,
                                      tags: { mutable_tags: mutable_tags, immutable_tags: immutable_tags }.with_indifferent_access)
    end

    def self.get_group(id)
      ::Hws::Transactions::Models::TransactionGroup.find(id)
    end

    # tags: hash of the form mentioned below.
    # {
    #   'mutable_tags' => {mutable_tag_key1 => m_tag_val1, mutable_tag_key2 => m_tag_val2},
    #   'immutable_tags' => {immutable_tag_key1 => i_tag_val1, immutable_tag_key2 => i_tag_val2}
    # }
    def self.add_entry(transaction_group_id, value, txn_time, tags)
      self.get_group(transaction_group_id).try(:add_entry, value, txn_time, tags.with_indifferent_access)
    end

    def self.update_entry(transaction_group_id, entry_id, mutable_tags)
      self.get_group(transaction_group_id).try(:update_entry, entry_id, mutable_tags.with_indifferent_access)
    end

    # filters: hash of the form mentioned below.
    # {
    #   'col1' => 'val1',
    #   'col2' => 'val2',
    #   'mutable_tags' => {
    #     'jsonf1' => 'val1',
    #     'jsonf2' => {'nested_jsonf3' => 'val2'}
    #   }
    #   'immutable_tags' => {
    #     'jsonf1' => 'val1',
    #     'jsonf2' => {'nested_jsonf3' => 'val2'}
    #   }
    # }
    # pagination_context: hash of the form mentioned below.
    # {
    #   'last_entry': '',
    #   'page_size': 10
    # }
    def self.list_entries(transaction_group_id, filters = {}, page_context = {})
      self.get_group(transaction_group_id).try(:list_entries, filters.with_indifferent_access, page_context.with_indifferent_access)
    end

    def self.get_entry(entry_id)
      entry = ::Hws::Transactions::Models::TransactionEntry.find_by(id: entry_id)
      { id: entry.id, transaction_group_id: entry.transaction_group_id, value: entry.value, txn_time: entry.txn_time,
        tags: { immutable_tags: entry.immutable_tags, mutable_tags: entry.mutable_tags } }
    end

    module Models # :nodoc:
    end
  end
end

require 'hws-transactions/models/transaction_entry'
require 'hws-transactions/models/transaction_group'

# rubocop:enable Naming/FileName
