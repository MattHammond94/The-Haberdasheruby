The Haberdasheruby!
=================

The Haberdasheruby is a small terminal program allowing the user to manage a shops database that contains some items and some orders.

User stories:
-------

```
As a shop manager
So I can know which items I have in stock
I want to keep a list of my shop items with their name and unit price.

As a shop manager
So I can know which items I have in stock
I want to know which quantity (a number) I have for each item.

As a shop manager
So I can manage items
I want to be able to create a new item.

As a shop manager
So I can know which orders were made
I want to keep a list of orders with their customer name.

As a shop manager
So I can know which orders were made
I want to assign each order to their corresponding item.

As a shop manager
So I can know which orders were made
I want to know on which date an order was placed. 

As a shop manager
So I can manage orders
I want to be able to create a new order.
```

Here's an example of the terminal output your program should generate (yours might be slightly different — that's totally OK):

```
Welcome to the shop management program!

What do you want to do?
  1 = list all shop items
  2 = create a new item
  3 = list all orders
  4 = create a new order

1 [enter]

Here's a list of all shop items:

 #1 Super Shark Vacuum Cleaner - Unit price: 99 - Quantity: 30
 #2 Makerspresso Coffee Machine - Unit price: 69 - Quantity: 15
 (...)
```

Technical Approach:
-----

This program follows the Model, Repository and Database connection framework to implement the programs core functionality. 

The Database connection class makes use of the ruby gem 'PG' and is used to establish a connection to the database used for this program.

The Model class' are ```item``` and ```order``` each with their own respective attributes and their own respoective repository class. 

The repository class' are used to interact with the database using SQL syntax.

View the ```recipe.md``` file for further notes and details on how I approached this project.

## Installation 
Run the below from the command line:

```
git clone https://github.com/MattHammond94/The-Haberdasheruby.git
cd The-Haberdasheruby
bundle install
```

You will then need to create a database and create the tables within the database:

Note - currently the program uses a database named 'shop_manager'. If you wish to change this and use a different databse you will need to adjust the database name to your chosen database on line 96 of app.rb.

```
createdb shop_manager
psql -h 127.0.0.1 shop_manager < ./spec/DB_table_setup.sql
```
If using table plus you may then want to select ```cmd+R``` to refresh the database and see your created tables.

===
Notes on using a database for tests:

If you are planning on using rspec to run tests and also view the current test coverage then a further test database will need to be created and seeded with the correct tables: 

from the command line run:
```
createdb shop_manager_test
psql -h 127.0.0.1 shop_manager_test < ./spec/DB_table_setup.sql
```

then run: 
 ```
 rspec
 ```

On line 5 of the spec_helper file you can see that the tests currently use the database ```'shop_manager_test'``` If you have chosen to use a different database name for your tests ensure this is updated accordingly. Also note that the test files are currently coded to reset the tables in the database after each test. If creating your own seed files for tests please ensure this is also updated in the spc files to avoid further fails (see line 5 in the respective spec files.)


## Running the program

To run the program run ```ruby app.rb``` from the command line and follow the prompts.

## Notes

I would like to return to this project at a later date to make some further amendments as there are still some important issues that need to be addressed. 

Most of these issues revolve around user input as there are many times user input is required and I have only written a few error handlers due to time constraints.

I would like to add further fail/error handlers at these stages: 

> When creating an item:
> Ensure the name is always an acceptable string (Acceptable would need to be defined and then represented as a regex - Can also add length of string param)
> Ensure the price is an acceptable float value, greater than 0.00 and is formatted correctly.
> Ensure the quantity is an acceptable int value always greater than 0.

> When deleting an item:
> Ensure the id taken from user is only ever an int between 1-max item id in DB.
> Ensure the id taken does exist in DB.
> => if .id < 1 || > repo.all.length

> When updating an item:
> Ensure the id taken is only ever an integer.
> Ensure this id does exist in DB.
> Ensure the new price is an acceptable float value => regex => ".match?(/\d+.\d+/) else fail"
> Allow user to update other elements (Not just the price.)

> When creating a new order:
> Ensure the name is always an acceptable string (Acceptable would need to be defined and then represented as a regex - Can also add length of string param)
> Ensure the id taken is an int only, > 0 and does exist in DB.

> Whilst adding further fail params. I would also like to use this opportunity to look further into SQL. Commands like 'Not Null' and VARCHAR could aid in my error handling to ensure I am only getting exactly what I want when user is given the option to input a value.

> Other changes/improvements that can be made:
> When listing all items ensure they are ordered in order of ID after items have been updated.
> When listing all orders showcase the name of the items that have been ordered.
> When an Order has been made update the Quantity of the Item automatically.
> Prevent the ordering of an item is its Quantity < 0.
> Reformat the date displayed when order list is displayed.
> Code needs to be reactored where possible to meet rubocop params.
