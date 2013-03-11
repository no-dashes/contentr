[![Build Status](https://secure.travis-ci.org/Crunch09/contentr.png)](http://travis-ci.org/Crunch09/contentr)

# WARNING: Under heavy development

I think I should write that this gem is not yet production
ready. So you should probably wait a bit if you want
to use that.

# Contentr -  The embeddable CMS Engine

## Installation

First add contentr and the edge version of `carrierwave` to your Gemfile
```ruby
  gem 'contentr', git: "git://github.com/no-dashes/contentr.git"
  gem 'carrierwave', git: 'git://github.com/jnicklas/carrierwave.git'
```

Then run the `bundle` command.

Copy the migrations and run them:

`rake contentr_engine:install:migrations db:migrate`

After that run the install generator.

`rails g contentr:install`

In order to use `contentr` properly you need to override two methods in your **ApplicationController**:

`contentr_authorized?` and `contentr_publisher?`

## Usage

to make a controller serve the contentr pages:

in <tt>routes.rb</tt> add

```ruby
  get '/whatever/path/you/like/*contentr_path' => 'contentr/pages#show', :as => 'contentr'
```

To use linked pages in a view, add <tt>contentr</tt> to the corresponding view.

By default, contentr will look for <tt>Contentr::LinkedPage</tt>s with a <tt>linked_to</tt> attribute like this:

* <tt>controller#action:id</tt> if an <tt>id</tt> is present
* <tt>controller#action</tt>
* <tt>controller#*</tt>

If you put a <tt>contentr "<i>link_key</i>"</tt> into your action, the <tt>Contentr::LinkedPage</tt> with the given link_key will be loaded.

To enable the <i>old-school</i> linked_to behaviour just put a <tt>before_filter :contentr</tt> into your controller(s).
