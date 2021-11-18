# Hws::Transactions

**Financial Primitive - Transaction**

Any financial usecase will have the need to maintain the list of transactions performed. This is the primitive library to manage them.
There are two entities - TransactionGroup and TransactionEntry.

- TransactionGroup - This can be used to dictate the type of transaction and provide the scheme for the entries.
- TransactionEntry - These are the actual transactions that occur in the usecase.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hws-transactions'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hws-transactions

## Usage

### Generate migration file:
The gem needs two tables transaction_groups and transaction_entries. They can be created by running the following commands.
```
    $ bundle exec rails generate hws:transaction:install
    $ bundle exec rake db:migrate
```

### Create a transaction group
```ruby
Hws::Transactions.create_group('Vendor Payments', 'Track Vendor Payments Sent', ['status', 'vendor_acknowledged'], ['vendor_name', 'invoice_number', 'payment_date'])
=> #<Hws::Transactions::Models::TransactionGroup id: "619f676d-085a-f890-9f73-6b6821ea1cad", name: "Vendor Payments", description: "Track Vendor Payments Sent", tags: {"mutable_tags"=>["status", "vendor_acknowledged"], "immutable_tags"=>["vendor_name", "invoice_number", "payment_date"]}, created_at: "2021-11-25 10:37:33", updated_at: "2021-11-25 10:37:33"> # returns the TransactionGroup object which was created
```

### Get a transaction group
```ruby
Hws::Transactions.get_group("619f676d-085a-f890-9f73-6b6821ea1cad")
=> #<Hws::Transactions::Models::TransactionGroup id: "619f676d-085a-f890-9f73-6b6821ea1cad", name: "Vendor Payments", description: "Track Vendor Payments Sent", tags: {"mutable_tags"=>["status", "vendor_acknowledged"], "immutable_tags"=>["vendor_name", "invoice_number", "payment_date"]}, created_at: "2021-11-25 10:37:33", updated_at: "2021-11-25 10:37:33">
```

### Add a transaction entry
```ruby
Hws::Transactions.add_entry("619f676d-085a-f890-9f73-6b6821ea1cad", 15.25, Time.now, { mutable_tags: {status: 'SENT', 'vendor_acknowledged': true}, immutable_tags: {vendor_name: 'ACME Inc', invoice_number: 'DEMO123', payment_date: '2021-11-25'}})
=> #<Hws::Transactions::Models::TransactionEntry id: "619f6e3d-2090-e0a0-668d-d4da170b77c0", transaction_group_id: "619f676d-085a-f890-9f73-6b6821ea1cad", value: 15, txn_time: "2021-11-25 11:06:37", immutable_tags: {"vendor_name"=>"ACME Inc", "invoice_number"=>"DEMO123", "payment_date"=>"2021-11-25"}, mutable_tags: {"status"=>"SENT", "vendor_acknowledged"=>false}, created_at: "2021-11-25 11:06:37", updated_at: "2021-11-25 11:06:37">
```

### Update a transaction entry
```ruby
Hws::Transactions.update_entry("619f676d-085a-f890-9f73-6b6821ea1cad", "619f6e3d-2090-e0a0-668d-d4da170b77c0", {status: 'COMPLETED', 'vendor_acknowledged': true})
=> true # Update successful
```

### Fetch a transaction entry list
```ruby
Hws::Transactions.list_entries("619f676d-085a-f890-9f73-6b6821ea1cad", {immutable_tags: {invoice_number: 'DEMO123'}}, {page_size: 10})
=> #<ActiveRecord::AssociationRelation [#<Hws::Transactions::Models::TransactionEntry id: "619f6e3d-2090-e0a0-668d-d4da170b77c0", transaction_group_id: "619f676d-085a-f890-9f73-6b6821ea1cad", value: 15, txn_time: "2021-11-25 11:06:37", immutable_tags: {"vendor_name"=>"ACME Inc", "payment_date"=>"2021-11-25", "invoice_number"=>"DEMO123"}, mutable_tags: {"status"=>"COMPLETED", "vendor_acknowledged"=>true}, created_at: "2021-11-25 11:06:37", updated_at: "2021-11-25 11:07:04">]>

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hwslabs/hws-transactions-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
