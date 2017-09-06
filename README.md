# HashAccessor

[![Build Status](https://travis-ci.org/GetJobber/hash_accessor.png?branch=testing)](https://travis-ci.org/GetJobber/hash_accessor) [![Coverage Status](https://img.shields.io/coveralls/GetJobber/hash_accessor.svg)](https://coveralls.io/r/GetJobber/hash_accessor) [![Code Climate](https://codeclimate.com/github/GetJobber/hash_accessor.png)](https://codeclimate.com/github/GetJobber/hash_accessor)

This gem provides similar functionality to Rails' new ActiveAttr, except with a bunch of powerful methods behind it. Type definitions, defaults, lambdas on arrays, and more.

The purpose behind building HashAccessor was to be able to quickly add/modify/remove variables being stored in a serialized hash of a rails model. This is very useful if you have a large list of often changing variables on a model which don't get queried against. You can create new variables without messing up your DB. Storing account configurations or custom themes is a common scenario.

This gem was designed to have HTML forms update directly to the hash, but maintain the correct class (respecting :attr_accessible of course). Options like :default, :type, and :collects are particularly helpful when dealing with forms.

## Installation

In your Gemfile:

```
gem "hash_accessor"
```

Then run:

```
bundle install
```

## Usage

You define each accessor you want to be stored inside the serialized hash:

```
hash_accessor _NAME_OF_HASH_, _NAME_OF_VARIABLE_, options
```

Here is an example:

```ruby
class MyModel < ActiveRecord::Base
  serialize :options, Hash

  hash_accessor :options, :currency, :default => "$USD"
  hash_accessor :options, :display_currency_on_invoices, :type => :boolean, :default => true
  hash_accessor :options, :invoice_due_date_net, :type => :integer, :default => 3


  def some_method

    self.currency = "$CAD"

    display_currency_on_invoices?

    # ...
  end

end
```

### Valid Options:

`:default` - if undefined, this plugin will create an empty instance of the defined type or null

`:type` - defaults to :string. Can also be :integer, :float, :decimal, :boolean, or :array

#### For Arrays only:

`:collects` - only runs on arrays. Calls the lambda method on each item in the array before saving

`:reject_blanks` - removes all blank elements after the collect method. This with :collects can be used together for storing a list of ids stored as checkboxes in a form.



## Contributing & Reporting Issues

Please feel free to report any issues, provide feedback, or make suggestions on the [Issue Tracker](http://github.com/GetJobber/hash_accessor/issues)

Tests can be ran against different versions of Rails like so:

```
BUNDLE_GEMFILE=test/gemfiles/Gemfile.rails-3.2.x bundle install
BUNDLE_GEMFILE=test/gemfiles/Gemfile.rails-3.2.x bundle exec rake test
```

---


Copyright (c) 2014-2017 OctopusApp Inc. ([getjobber.com](http://getjobber.com)), released under the MIT license
