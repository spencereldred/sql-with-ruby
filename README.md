# SQL with Ruby

We have looked at writing SQL commands against a database using the `psql` tool.
While this is a great way to learn SQL and to write ad-hoc commands, it is
preferable to execute SQL commands directly from Ruby code. As an intermediate
step between writing SQL in psql and writing Ruby code that generates the SQL
commands we want to run, this exercise will introduce the concept of connecting
to a database with Ruby and executing SQL commands through that connection.

We will create a new database for this exercise but will use the same database schema as
[https://github.com/gSchool/sql-query-exercise](https://github.com/gSchool/sql-query-exercise).
The SQL queries you will write will be very similar to some of the queries from that exercise,
only now you will be writing Ruby code to make those queries.

## Setup

1. Fork and clone this repository
1. `cd` into the repository directory
1. `bundle install`
1. Create the databaes for the exercise by opening 'psql' and typing the command `CREATE DATABASE exercisedbruby;`
1. Import the tables and data by running `psql -d exercisedbruby -a -f restore.sql -U gschool` from the command line

## Exercise

Your goal is to make all the tests in `spec/sql_exercise_spec.rb` pass. Run `rspec`
and you will see a single failing test. After you make that test pass, find the next
test in the test file and delete the line that says `skip`. Continue this process
until you have removed all the `skips` in the test file and all the tests pass.

## Example

You will start with a handful of tests and an example implementation of a method
that runs SQL from Ruby.

There is one example included in this repository with a passing test. If you look in
`spec/sql_exercise_spec.rb` you'll see something like this:

    describe SqlExercise do

      let(:sql_exercise) { SqlExercise.new }

      describe "#all_customers" do
        it "returns a hash of all the customer data" do
          customers = sql_exercise.all_customers

          expect(customers.length).to eq(10)

          first_customer = customers.first

          expect(first_customer["name"]).to eq("Donato Rempel")
          expect(first_customer["email"]).to eq("ladarius@waelchi.org")
        end
      end
    end

This test create an instance of the SqlExercise class, calls the #all_customers
method, and sets an expectation that there are 10 customers in total, and that
the first customer is named "Donato Rempel" with an email address of
"ladarius@waelchi.org".

Let's look at the implementation that makes this test pass:

    require "database_connection"

    class SqlExercise

      attr_reader :database_connection

      def initialize
        @database_connection = DatabaseConnection.new
      end

      def all_customers
        database_connection.sql("SELECT * from customers")
      end

    end

The #all_customers method uses the #sql method of the database connection to
send a SQL query to the database. The return value of calling the #sql method
is an array of hashes, so calling all customers return an array where each
element is a hash representing a customer, similar to:

    {"id"=>"1", "name"=>"Donato Rempel", "email"=>"ladarius@waelchi.org", "address"=>"890 Ullrich Plains", "city"=>"Janachester", "state"=>"Virginia", "zipcode"=>"77714"}

If you run "SELECT * FROM customers;" after connecting the to exercisedb database with psql, you'll
see that the user with id 1 has the same attribtues as the hash above.

## Database Configuration

When you run psql from the command line, it uses some default connection information
to connect to the database you want to run SQL queries against. Ruby doesn't
know about this default connection information, so you need to tell Ruby how to
connect to the database.

In this project, we are storing our database connection information in a separate
file from our Ruby code. This is a common pattern and makes it easy for our Ruby
code to connect to different databases (test, development, production) without
having to change.

The file in `config/database.yml` defines the connection options that our Ruby code
uses to connect to the database:

    development:
      adapter: postgresql
      encoding: unicode
      database: exercisedb
      username: gschool
      password:

We are telling Ruby that we want to connection to a Postgres database server, that
the name of the database RUby should connect to i `exercisedb`, the username Ruby
use to connect to the database is `gschool` (we created this Postgres user yesterday),
and the password Ruby should use to connect to the database is blank.
