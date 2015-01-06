require 'pg'
require 'json'


module PetShopServer
  class DogsRepo
    # select all dogs given a shop id
    def self.all db, shop_id
      sql = %q[SELECT * FROM dogs where shopId = $1]
      result = db.exec(sql, [shop_id])
      JSON.generate(result.entries)
    end

    # select all dogs owned by a given owner id
    def self.find_by_owner_id db, user_id
      sql = %q[SELECT * FROM dogs where owner = $1]
      result = db.exec(sql, [user_id])
      result.entries
    end

  end
end