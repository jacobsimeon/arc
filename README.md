#Arc (**AR**el **C**onnection)
Arc lets you use arel without the cost of including active record as a dependency.
[Arel][1] is a very capable and [inspired][2] bit of code which provides machinery for building an [abstract syntax tree][2](ast) of a complex sql query in pure ruby.

##Arc is:
Arc is a database connection engine that provides everything Arel needs to construct an AST.
You can use sqlite, postgresql and/or mysql.
Arc handles quoting and casting of values when you create or update records and results are wrapped in lazy loading arrays and hashes.
Arc provides a standard and **thread safe** CRUD interface for executing queries
Arc datastores have a hash-like interface that provides information about the tables and columns in your database:
Arc has two dependencies: [q][6] and arel itself.
##Arc is *not*:
Arc isn't an ORM.
There has been some [recent discussion][4] about the state of ruby ORMs.  Arc does not make any attempt to [pass judgement][5] against any of the fine ORMs out there.  Arc came out of a need for a lighter weight method for manipulating data in a database.  Arc gives developers flexibility to build their own frameworks and write smaller libraries with fewer dependencies.

##Installation
Add this to your Gemfile
    gem 'pg' #'mysql2' or 'sqlite'
    gem 'arc'

##Basics
Connect to a database:
Arc will automatically load in and require the adapter you request
The arguments that get passed to the constructor are similar (if not identical) to the arguments for ActiveRecord::Base.establish_connection
    require 'arc'
    @store = Arc::DataStores[:postgres].new({
      database: arc_development,
      host: localhost,
      user: superman
    })
    @store[:superheros]
    # => <Arc::DataStores::ObjectDefinitions::SqliteTable:0x007f86d4026f68 @name="superheros">
    @store[:superheros].column_names
    # => [:is_awesome, :name, :id ]
    @store[:superheros][:id]
    # => #<Arc::DataStores::ObjectDefinitions::SqliteColumn @name='id'>
    @store[:superheros][:id].primary_key?
    # => true
    @store[:superheros][:is_awesome].type
    # => :bool
    
####Execute a query
Build an Arel query and pass it to one of the store's CRUD methods:

"Read" Example:

    s = Arel::Table.new :superheros
    s.project(s[:name], s[:id], s[:is_awesome])
    @store.read s
    # => [{ :id => 1, :name => 'superman', :is_awesome => true  }
    # =>  { :id => 2, :name => 'batman',   :is_awesome => false }
    # =>  { :id => 3, :name => 'ironman',  :is_awesome => nil   }]

"Create" example

    im = Arel::InsertManager.new
    im.insert([
      [superheros[:name], 'green hornet'],
      [superheros[:is_awesome], true]
    ])
    @store.create im
    # => { :id => 4, :name => 'green hornet', :is_awesome => true }

##Advanced


[1]: http://github.com/rails/arel
[2]: http://twitter.com/#!/jacobsimeon/status/97183215013466113
[3]: http://en.wikipedia.org/wiki/Abstract_syntax_tree
[4]: http://solnic.eu/2011/11/29/the-state-of-ruby-orm.html
[5]: https://github.com/garybernhardt/base
[6]: http://github.com/jacobsimeon/q