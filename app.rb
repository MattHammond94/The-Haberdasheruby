require_relative 'lib/database_connection'
require_relative 'lib/item_repository'
require_relative 'lib/order_repository'
require 'date'

class Application 

  def initialize(database_name, io, item_repository, order_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @item_repository = item_repository
    @order_repository = order_repository
  end

  def run
    while true do 
      @io.puts "What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program"
      selection = @io.gets.chomp
      if selection == "1"
        selection_1
      elsif selection == "2"
        selection_2
      elsif selection == "3"
        selection_3
      elsif selection == "4"
        selection_4
      elsif selection == "5"
        selection_5
      elsif selection == "6"
        selection_6
      elsif selection == "7"
        break
      else
        fail "This is not a valid selection"
      end
    end
  end

  private

  def selection_1
    @item_repository.all.each do |item| 
      @io.puts "##{item.id} - #{item.item_name} - Unit price: #{format('%.2f', item.unit_price)} - Quantity: #{item.quantity}"
    end
  end

  def selection_2
    item = Item.new
    @io.puts "Enter the items name:"
    item.item_name = @io.gets.chomp
    @io.puts "Enter the items price:"
    item.unit_price = @io.gets.chomp.to_f
    @io.puts "Enter the items quantity:"
    item.quantity = @io.gets.chomp
    @item_repository.create(item)
    @io.puts "#{item.item_name} has been added to your inventory"
  end

  def selection_3
    
  end

  def selection_4

  end

  def selection_5
    @order_repository.all.each do |order| 
      @io.puts "##{order.id} - Customer name: #{order.customer_name} - Date placed: #{order.date_placed}"
    end
  end

  def selection_6
    order = Order.new
    @io.puts "Enter the customer name for this order:"
    order.customer_name = @io.gets.chomp
    order.date_placed = Date.today
    @io.puts "Enter the item id assosciated with this order:"
    order.item_id = @io.gets.chomp
    @order_repository.create(order)
    @io.puts "#{order.customer_name}'s order has been added to your order list"
  end
end

if __FILE__ == $0
  app = Application.new(
    'shop_manager',
    Kernel,
    ItemRepository.new,
    OrderRepository.new
  )
  app.run
end

# I would like to add further fail/error tests for this program specifically around the user input stages

# For item:
# Ensure the name is always an acceptable string (Acceptable would need to be defined as a regex)
# Ensure that the unit price is always seperated by a dot - regex => ".match?(/\d+.\d+/) else fail"

# For order:
# Throw a fail if the item id is < 1 || > repo.all.length 

# Code also needs to be reactored where possible to meet rubocop params.

# (This will be added/amended at a later date)
