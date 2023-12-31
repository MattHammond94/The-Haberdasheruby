require_relative '../app'

describe Application do 

  def reset_tables
    seed_sql = File.read('spec/shop_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  it 'Should return all shop items in a list when 1 is selected by user' do
    io = double :io
    order_repo = double :order
    item_repo = ItemRepository.new
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("1").ordered
    expect(io).to receive(:puts).with("#1 - Candlestick - Unit price: 1.99 - Quantity: 10").ordered
    expect(io).to receive(:puts).with("#2 - Lead-Pipe - Unit price: 4.45 - Quantity: 3").ordered
    expect(io).to receive(:puts).with("#3 - Gun - Unit price: 12.95 - Quantity: 1").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
  end

  it 'Should create a new item and add it to the DB when 2 is selected' do
    io = double :io
    order_repo = double :order
    item_repo = ItemRepository.new
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("2").ordered
    expect(io).to receive(:puts).with("Enter the items name:").ordered
    expect(io).to receive(:gets).and_return("Dagger").ordered
    expect(io).to receive(:puts).with("Enter the items price:").ordered
    expect(io).to receive(:gets).and_return("14.99").ordered
    expect(io).to receive(:puts).with("Enter the items quantity:").ordered
    expect(io).to receive(:gets).and_return("3").ordered
    expect(io).to receive(:puts).with("Dagger has been added to your inventory").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
    expect(item_repo.all.length).to eq 4
    expect(item_repo.all.last.item_name).to eq 'Dagger'
    expect(item_repo.all.last.unit_price).to eq 14.99
  end

  it 'Should delete the selected item from the database when 3 is selected' do
    io = double :io
    order_repo = double :order
    item_repo = ItemRepository.new
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("3").ordered
    expect(io).to receive(:puts).with("Enter the id for item you wish to delete").ordered
    expect(io).to receive(:gets).and_return("1").ordered
    expect(io).to receive(:puts).with("Candlestick has been removed from your inventory").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
    expect(item_repo.all.length).to eq 2
    expect(item_repo.all.first.item_name).to eq 'Lead-Pipe'
  end

  it 'Should update the price of the selected item when 4 is selected' do
    io = double :io
    order_repo = double :order
    item_repo = ItemRepository.new
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("4").ordered
    expect(io).to receive(:puts).with("Enter the id for item you wish to update").ordered
    expect(io).to receive(:gets).and_return("2").ordered
    expect(io).to receive(:puts).with("Enter the new price for this item").ordered
    expect(io).to receive(:gets).and_return("29.99").ordered
    expect(io).to receive(:puts).with("The price of Lead-Pipe has been updated").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
    expect(item_repo.all.last.unit_price).to eq 29.99
  end

  it 'Should return all shop orders in a list when 5 is selected by user' do
    io = double :io
    order_repo = OrderRepository.new
    item_repo = double :item
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("5").ordered
    expect(io).to receive(:puts).with("#1 - Customer name: Professor Plum - Date placed: 2023-12-12").ordered
    expect(io).to receive(:puts).with("#2 - Customer name: Colonel Mustard - Date placed: 2023-12-12").ordered
    expect(io).to receive(:puts).with("#3 - Customer name: Miss Scarlet - Date placed: 2023-03-09").ordered
    expect(io).to receive(:puts).with("#4 - Customer name: Reverend Green - Date placed: 2023-12-12").ordered
    expect(io).to receive(:puts).with("#5 - Customer name: Mrs Peacock - Date placed: 2023-12-12").ordered
    expect(io).to receive(:puts).with("#6 - Customer name: Chef White - Date placed: 2023-10-10").ordered
    expect(io).to receive(:puts).with("#7 - Customer name: Miss Peach - Date placed: 2023-10-06").ordered
    expect(io).to receive(:puts).with("#8 - Customer name: Madame Rose - Date placed: 2023-07-11").ordered
    expect(io).to receive(:puts).with("#9 - Customer name: Lady Lavender - Date placed: 2023-08-12").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
  end

  it 'Should create a new order object and add it to the DB when 6 is selected' do
    io = double :io
    date = Date.today
    order_repo = OrderRepository.new
    item_repo = double :item
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("6").ordered
    expect(io).to receive(:puts).with("Enter the customer name for this order:").ordered
    expect(io).to receive(:gets).and_return("Lord Gray").ordered
    expect(io).to receive(:puts).with("Enter the item id assosciated with this order:").ordered
    expect(io).to receive(:gets).and_return("2").ordered
    expect(io).to receive(:puts).with("Lord Gray's order has been added to your order list").ordered
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
    expect(order_repo.all.length).to eq 10
    expect(order_repo.all.last.customer_name).to eq 'Lord Gray'
    expect(order_repo.all.last.date_placed).to eq "#{date}"
    expect(order_repo.all.last.item_id).to eq '2'
  end

  it 'Should break the loop when 7 is selected by user' do
    io = double :io
    order_repo = OrderRepository.new
    item_repo = double :item
    expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
    expect(io).to receive(:gets).and_return("7").ordered
    app = Application.new('shop_manager_test', io, item_repo, order_repo)
    app.run
  end

  context 'fail/error testing' do
    it 'Should return an error if the user input is anything other than selectable options.' do
      io = double :io
      order_repo = double :order
      item_repo = double :item
      expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
      expect(io).to receive(:gets).and_return("8").ordered
      app = Application.new('shop_manager_test', io, item_repo, order_repo)
      expect { app.run }.to raise_error "This is not a valid selection"
    end

    it 'Should return an error if the user input is anything other than selectable options.' do
      io = double :io
      order_repo = double :order
      item_repo = double :item
      expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
      expect(io).to receive(:gets).and_return("String").ordered
      app = Application.new('shop_manager_test', io, item_repo, order_repo)
      expect { app.run }.to raise_error "This is not a valid selection"
    end

    it 'Should return an error if the user input is anything other than selectable options.' do
      io = double :io
      order_repo = double :order
      item_repo = double :item
      expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
      expect(io).to receive(:gets).and_return("-1").ordered
      app = Application.new('shop_manager_test', io, item_repo, order_repo)
      expect { app.run }.to raise_error "This is not a valid selection"
    end

    it 'Should return an error if the user input is anything other than selectable options.' do
      io = double :io
      order_repo = double :order
      item_repo = double :item
      expect(io).to receive(:puts).with("What do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = Delete an item\n4 = Change an items price\n5 = list all orders\n6 = create a new order\n7 = close program").ordered
      expect(io).to receive(:gets).and_return(")()):xcqqQ").ordered
      app = Application.new('shop_manager_test', io, item_repo, order_repo)
      expect { app.run }.to raise_error "This is not a valid selection"
    end
  end
end
