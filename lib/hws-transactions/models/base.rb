# frozen_string_literal: true

module Hws::Transactions::Models
  class Base < ActiveRecord::Base # :nodoc:
    self.abstract_class = true

    before_create :set_uuid

    def set_uuid
      self.id = LSUUID.generate if self.id.blank?
    end
  end
end
