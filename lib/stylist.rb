class Stylist
  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_stylists = DB.exec("SELECT * FROM stylists;")
    stylists = []
    returned_stylists.each() do |stylist|
      name = stylist.fetch('name')
      id = stylist.fetch('id').to_i()
      stylists.push(Stylist.new({:name => name, :id => id}))
    end
    stylists
  end

  def ==(another_stylist)
    self.name().==(another_stylist.name())
  end

  def save
    result = DB.exec("INSERT INTO stylists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def self.find(id)
    found_stylist = nil
    Stylist.all().each() do |stylist|
      if stylist.id().==(id)
        found_stylist = stylist
      end
    end
    found_stylist
  end

  def update(attributes)
    @name = attributes.fetch(:name)
    @id = self.id()
    DB.exec("UPDATE stylists SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM stylists WHERE id = #{self.id()};")
  end

  def find_clients
    stylists_clients = []
    clients = DB.exec("SELECT * FROM clients WHERE stylist_id = #{self.id()};")
    clients.each() do |client|
      name = client.fetch("name")
      stylist_id = client.fetch("stylist_id").to_i()
      id = client.fetch('id').to_i()
      stylists_clients.push(Client.new({:id => nil, :name => name, :stylist_id => stylist_id}))
    end
    stylists_clients
  end
end
