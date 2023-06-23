require_relative './item'

class ItemRepository

  def all
    result = DatabaseConnection.exec_params('SELECT * FROM items;', [])
    all_items = []
    result.each do |row| 
      item = Item.new
      item.id = row['id']
      item.item_name = row['item_name']
      item.unit_price = row['unit_price'].to_f
      item.quantity = row['quantity']
      all_items << item
    end
    all_items
  end

  def create(item)
    sql = 'INSERT INTO items(item_name, unit_price, quantity) VALUES($1, $2, $3);'
    params = [item.item_name, item.unit_price, item.quantity]
    DatabaseConnection.exec_params(sql, params)
  end

  def find(id)
    sql = 'SELECT * FROM items WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql, [id])
    item = Item.new
    item.id = result[0]['id'].to_i
    item.item_name = result[0]['item_name']
    item.unit_price = result[0]['unit_price'].to_f
    item.quantity = result[0]['quantity']
    item
  end

  def remove(id)
    sql = 'DELETE FROM items WHERE id = $1'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(item)
    sql = 'UPDATE items SET unit_price = $1 WHERE id = $2'
    params = [item.unit_price, item.id]
    DatabaseConnection.exec_params(sql, params)
  end
end
