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

#updatera/editera frukter
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

#skappa frukt
get('/fruits/new') do

  slim(:"fruits/new")
end


#skappar frukt
post('/fruit') do
  new_fruit = params[:new_fruit] # Hämta datan ifrån formuläret
  amount = params[:amount].to_i 
  db = SQLite3::Database.new('db/fruits.db') # koppling till databasen
  db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[new_fruit,amount])
  redirect('/fruits') # Hoppa till routen som visar upp alla frukter
end




get('/animals') do
  db = SQLite3::Database.new("db/animals.db")

  #[{},{},{}] önskar vi oss
  db.results_as_hash = true

  @dataanimals = db.execute("SELECT * FROM animals")
  p @dataanimals

  query = params[:q]
  p "jag skrev #{query}"
  @alla = 0
  if query && !query.empty?
    @dataanimals = db.execute("SELECT * FROM animals WHERE name LIKE ?","%#{query}")
  else
    @dataanimals = db.execute("SELECT * FROM animals")
  end


  #visa upp med slim
  slim(:"animals/index")

end


get('/animals/:id/edit') do
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @special_animal = db.execute("SELECT * FROM animals WHERE id = ?",id).first
  #visa formulär för att uppdatera
  slim(:"animals/edit")
end


#Ta bort en animal
post('/animals/:id/delete') do
  #hämta animals
  id = params[:id].to_i
  #Gör en koppling till data basen
  db = SQLite3::Database.new("db/animals.db")
  
  db.execute("DELETE FROM animals WHERE id = ?",id)

  redirect('/animals')
end

#updatera/editera animals
post('/animals/:id/update') do
  #plocka fram id, amount och name
  id = params[:id].to_i
  amount = params[:amount].to_i
  name = params[:name]

  db = SQLite3::Database.new("db/animals.db")
  db.execute("UPDATE animals SET name=?,amount=? WHERE id=?",[name,amount,id])



  redirect('/animals')
end


#skappa animal
get('/animals/new') do

  slim(:"animals/new")
end


#skappar animal
post('/animal') do
  new_animal = params[:new_animal] # Hämta datan ifrån formuläret
  amount = params[:amount].to_i 
  db = SQLite3::Database.new('db/animals.db') # koppling till databasen
  db.execute("INSERT INTO animals (name, amount) VALUES (?,?)",[new_animal,amount])
  redirect('/animals') # Hoppa till routen som visar upp alla animals
end
