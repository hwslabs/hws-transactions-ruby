# frozen_string_literal: true

require 'hws-transactions/models/base'

module Hws::Transactions::Models
  class TransactionEntry < Base
    belongs_to :transaction_group, class_name: 'TransactionGroup', foreign_key: 'transaction_group_id'
  end
end
