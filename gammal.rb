require 'sinatra'
require 'slim'
require 'sinatra/reloader'


get('/home') do
  slim(:home)

end

get('/fruits/:id') do
  fruits = ["äpple","päron","mango"]
  id = params[:id].to_i
  @fruits = fruits[id]
  slim(:fruits)
end


get('/about') do
  slim(:about)
end


get('/hash') do

  @cat = [
    {
    "name" => "Claws",
    "age" => "7"
    },
    {
    "name" => "Clor",
    "age" => "69"
    },
    {
    "name" => "ship",
    "age" => "5764"
    }
  ]

  slim(:caten)
end


