require 'pg'
require 'json'
#require '../pet-shop-server.rb'

module PetShopServer
  class CatsRepo
    # select all cats given a shop id
    def self.all db, shop_id
      sql = %q[SELECT * FROM cats where shopId = $1]
      result = db.exec(sql, [shop_id])
      JSON.generate(result.entries)
    end

    # select all dogs owned by a given owner id
    def self.find_by_owner_id db, user_id
      sql = %q[SELECT * FROM cats where owner = $1]
      result = db.exec(sql, [user_id])
      result.entries
    end
  end
end