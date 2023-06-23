require 'item_repository'

describe ItemRepository do
  def reset_items_table
    seed_sql = File.read('spec/item_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_items_table
  end

  it 'Should return all rows as an array of item objects when the all method is called' do
    repo = ItemRepository.new
    result = repo.all
    expect(result.length).to eq 3
    expect(result.first.id).to eq '1'
    expect(result.last.id).to eq '3'
    expect(result[1].item_name).to eq 'Lead-Pipe'
  end

  it 'Should take an item object and add a new row to the database' do
    repo = ItemRepository.new
    item = double :item, item_name: 'Big Skeng', unit_price: 3.99, quantity: 5
    repo.create(item)
    expect(repo.all.last.item_name).to eq 'Big Skeng'
    expect(repo.all.last.unit_price).to eq 3.99
    expect(repo.all.last.quantity).to eq '5'
    expect(repo.all.length).to eq 4
    expect(repo.all.last.id).to eq '4'
  end

  it 'Should return the chosen maker that corresponds with passed id' do
    repo = ItemRepository.new
    selected = repo.find(1)
    expect(selected.item_name).to eq ('Candlestick')
    expect(selected.unit_price).to eq (1.99)
  end

  it 'Should delete the passed item from the database' do
    repo = ItemRepository.new
    repo.remove(3)
    expect(repo.all.length).to eq 2
    expect(repo.all.last.id).to eq '2'
  end

  it 'Should update the price of a given item' do
    repo = ItemRepository.new
    item = repo.find(1)
    item.unit_price = 100.00
    repo.update(item)
    updated = repo.find(1)
    expect(updated.unit_price).to eq(100.00)
  end
end

describe ItemRepository do
  context 'Empty databse' do
    def reset_items_table
      seed_sql = File.read('spec/empty_seeds.sql')
      connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
      connection.exec(seed_sql)
    end

    before(:each) do
      reset_items_table
    end

    it 'Should return all rows as an array when the all method is called' do
      repo = ItemRepository.new
      expect(repo.all).to eq []
    end
  end
end
