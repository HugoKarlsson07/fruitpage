require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

#Ta bort en frukt
post('/fruits/:id/delete') do
  #hämta frukten
  id = params[:id].to_i
  #Gör en koppling till data basen
  db = SQLite3::Database.new("db/fruits.db")
  
  db.execute("DELETE FROM fruits WHERE id = ?",id)

  redirect('/fruits')
end

post('/fruits/:id/update') do
  #plocka fram id, amount och name
  id = params[:id].to_i
  amount = params[:amount].to_i
  name = params[:name]

  db = SQLite3::Database.new("db/fruits.db")
  db.execute("UPDATE fruits SET name=?,amount=? WHERE id=?",[name,amount,id])



  redirect('/fruits')
end



get('/fruits/:id/edit') do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @special_frukt = db.execute("SELECT * FROM fruits WHERE id = ?",id).first
  #visa formulär för att uppdatera
  slim(:"fruits/edit")
end

get('/fruits') do
  #Gör en koppling till data basen
  db = SQLite3::Database.new("db/fruits.db")

  #[{},{},{}] önskar vi oss
  db.results_as_hash = true

  @datafrukt = db.execute("SELECT * FROM fruits")
  p @datafrukt



  query = params[:q]
  p "jag skrev #{query}"
  @alla = 0
  if query && !query.empty?
    @datafrukt = db.execute("SELECT * FROM fruits WHERE name LIKE ?","%#{query}")
  else
    @datafrukt = db.execute("SELECT * FROM fruits")
  end


  #visa upp med slim
  slim(:"fruits/index")
end

get('/fruits/new') do

  slim(:"fruits/new")
end



post('/fruit') do
  new_fruit = params[:new_fruit] # Hämta datan ifrån formuläret
  amount = params[:amount].to_i 
  db = SQLite3::Database.new('db/fruits.db') # koppling till databasen
  db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[new_fruit,amount])
  redirect('/fruits') # Hoppa till routen som visar upp alla frukter
end


