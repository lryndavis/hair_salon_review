require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/client")
require("./lib/stylist")
require("pg")
require("pry")

DB = PG.connect({:dbname => 'hair_salon_test'})

get('/') do
  erb(:index)
end

get('/stylist_list') do
  @stylists = Stylist.all()
  erb(:stylist_list)
end

get('/client_list') do
  @clients = Client.all()
  erb(:client_list)
end

post('/stylist_list') do
  name = params.fetch("stylist")
  stylist = Stylist.new({:id => nil, :name => name})
  stylist.save()
  @stylists = Stylist.all()
  erb(:stylist_list)
end

get('/stylist_list/:id') do
  @stylist = Stylist.find(params.fetch("id").to_i())
  @clients = @stylist.find_clients()
  erb(:stylist)
end

post('/stylist/:id') do
  name = params.fetch("name")
  stylist_id = params.fetch("stylist_id").to_i()
  @stylist = Stylist.find(stylist_id)
  @clients = Client.new({:id => nil, :name => name, :stylist_id => stylist_id})
  @clients.save()
  @clients = @stylist.find_clients()
  erb(:stylist)
end

delete('/stylist/:id/delete') do
  @stylist = Stylist.find(params.fetch("id").to_i())
  @stylist.delete()
  @stylists = Stylist.all()
  erb(:stylist_list)
end

patch('/stylist/:id/edit') do
  name = params.fetch("update_name")
  @stylist = Stylist.find(params.fetch("id").to_i())
  @stylist.update({:name => name})
  @clients = @stylist.find_clients()
  erb(:stylist)
end

get('/client_list/:id') do
  @client = Client.find(params.fetch("id").to_i())
  erb(:client)
end

delete('/client_list/:id/delete') do
  @client = Client.find(params.fetch("id").to_i())
  @client.delete()
  @clients = Client.all()
  erb(:client_list)
end

patch('/client_list/:id/edit') do
  name = params.fetch("update_client")
  @client = Client.find(params.fetch("id").to_i())
  @client.update({:name => name})
  erb(:client)
end
