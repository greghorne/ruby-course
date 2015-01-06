require 'pg'
require 'rest-client'
require 'json'

require_relative 'repos/dogs_repo.rb'
require_relative 'repos/cats_repo.rb'
require_relative 'repos/shops_repo.rb'
require_relative 'repos/users_repo.rb'


module PetShopServer
  def self.create_db_connection(dbname)
    @db = PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.clear_db()
    @db.exec <<-SQL
      DELETE FROM dogs;
      DELETE FROM cats;
      DELETE FROM shops;
      DELETE FROM users
    SQL
  end

  def self.create_tables()
    @db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id SERIAL PRIMARY KEY,
        name VARCHAR,
        image_url VARCHAR,
        shop_id INTEGER,
        adopted VARCHAR,
        happiness INTEGER
      );
      CREATE TABLE IF NOT EXISTS cats(
        id SERIAL PRIMARY KEY,
        name VARCHAR,
        image_url VARCHAR,
        shop_id INTEGER,
        adopted VARCHAR
      );
      CREATE TABLE IF NOT EXISTS shops(
        id SERIAL PRIMARY KEY,
        name VARCHAR
      );
      CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        username VARCHAR,
        password VARCHAR
      );
    SQL
  end

  # def self.seed_db()
    # shops = RestClient.get "pet-shop.api.mks.io/shops"
    # parsed = JSON.parse(shops)
    # parsed.each do |shop| 
    #   db.exec(%q[
    #   INSERT INTO shops (name, id)
    #   VALUES ($1, $2)
    #   ], [shop['name'], shop['id']])
    # end

    # dogs = RestClient.get "pet-shop.api.mks.io/shops/dogs"
    # parsed_dogs = JSON.parse(dogs)
    # parsed_dogs.each do |dog|
    #   db.exec(%q[
    #   INSERT INTO dogs (name, image_url, happiness, shop_id, adopted, id)
    #   VALUES ($1, $2, $3, $4, $5, $6)
    #   ], [dog['name'], dog['image_url'], dog['happiness'], dog['shop_id'], dog['adopted'], dog['id']])
    # end

    # cats = RestClient.get "pet-shop.api.mks.io/shops/cats"
    # parsed_cats = JSON.parse(cats)
    # parsed_cats.each do |cat|
    #   db.exec(%q[
    #   INSERT INTO cats (name, image_url, happiness, shop_id, adopted, id)
    #   VALUES ($1, $2, $3, $4, $5)
    #   ], [cat['name'], cat['image_url'], cat['shop_id'], cat['adopted'], cat['id']])
    # end
  #end
  def self.insert_dog(dog_name, image_url, happiness, id, shop_id, adopted) #NICK's, similar to above (get_input)
    sql = %q[
      INSERT INTO dogs (dog_name, image_url, happiness, id, shop_id, adopted)
      VALUES ($1, $2, $3, $4, $5, $6)
    ]
    @db.exec_params(sql, [dog_name, image_url, happiness, id, shop_id, adopted])
  end

  def self.insert_cat(cat_name, image_url, id, shop_id, adopted) #NICK's, similar to above (get_input)
    sql = %q[
      INSERT INTO cats (cat_name, image_url, id, shop_id, adopted)
      VALUES ($1, $2, $3, $4, $5)
    ]
    @db.exec_params(sql, [cat_name, image_url, id, shop_id, adopted])
  end

  def self.insert_shop(shop_name, id)
    sql = %q[
      INSERT INTO shops (shop_name, id)
      VALUES ($1, $2)
    ]
    @db.exec_params(sql, [shop_name, id])
  end

  def self.populate_petshop()
    
    @db.exec("CREATE TABLE shops(shop_name VARCHAR, id SERIAL PRIMARY KEY)")
    @db.exec("CREATE TABLE dogs(dog_name VARCHAR, image_url VARCHAR, happiness INTEGER, id SERIAL PRIMARY KEY, shop_id INTEGER, adopted VARCHAR)")
    @db.exec("CREATE TABLE cats(cat_name VARCHAR, image_url VARCHAR, id SERIAL PRIMARY KEY, shop_id INTEGER, adopted VARCHAR)")

    shops = RestClient.get "pet-shop.api.mks.io/shops"
    parsed = JSON.parse(shops)
    parsed.each {|x| insert_shop(x["name"], x["id"])}

    i = 1
    while i < parsed.length
      dogs = RestClient.get "pet-shop.api.mks.io/shops/#{i}/dogs"
      cats = RestClient.get "pet-shop.api.mks.io/shops/#{i}/cats"

      parsed_dogs = JSON.parse(dogs)
      parsed_cats = JSON.parse(cats)

      parsed_dogs.each {|x| insert_dog(x["name"], x["imageurl"], x["happiness"], x["id"], x["shopId"], x["adopted"])}
      parsed_cats.each {|x| insert_cat(x["name"], x["imageurl"], x["id"], x["shopId"], x["adopted"])}

      i += 1
    end
  end

  # def self.drop_tables(db)
  #   db.exec <<-SQL
  #     DROP TABLE comments;
  #     DROP TABLE posts;
  #     DROP TABLE users;
  #   SQL
  # end
end