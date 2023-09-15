# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# require "json"
# require "rest-client"
# puts "Cleaning database..."
# Movie.destroy_all
# api_key = "<your_api_key>"
# response = RestClient.get "http://tmdb.lewagon.com/movie/top_rated?api_key=#{api_key}"
# data = JSON.parse(response.body)
# image_api = "https://image.tmdb.org/t/p/w500"
# puts "Creating fake movies..."
# data["results"].each do |movie_data|
#   title = movie_data["original_title"]
#   overview = movie_data["overview"]
#   poster_url = "#{image_api}#{movie_data['poster_path']}"
#   rating = movie_data["vote_average"]
#   Movie.create(title: title, overview: overview, poster_url: poster_url, rating: rating)
# end
# puts "Finished!"

require 'open-uri'
require 'json'

puts "Cleaning up database..."
Movie.destroy_all
puts "Database cleaned"

url = "http://tmdb.lewagon.com/movie/top_rated"
10.times do |i|
  puts "Importing movies from page #{i + 1}"
  movies = JSON.parse(URI.open("#{url}?page=#{i + 1}").read)['results']
  movies.each do |movie|
    puts "Creating #{movie['title']}"
    base_poster_url = "https://image.tmdb.org/t/p/original"
    Movie.create(
      title: movie['title'],
      overview: movie['overview'],
      poster_url: "#{base_poster_url}#{movie['backdrop_path']}",
      rating: movie['vote_average']
    )
  end
end
puts "Movies created"
