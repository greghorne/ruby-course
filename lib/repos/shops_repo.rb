require 'pg'
require 'json'


module PetShopServer
  class ShopsRepo
    # find a user by user ID. Intended to be used when
    # someone is already authenticated. We keep their
    # user id in the cookie.
    def self.all db
      sql = %q[SELECT * FROM shops]
      result = db.exec(sql)
      JSON.generate(result.entries)
    end




    # find user by username. Intended to be used when
    # someone tries to sign in.
    def self.find_by_name db, username
      sql = %q[SELECT * FROM users WHERE username = $1]
      result = db.exec(sql, [username])
      result.first
    end

    # when someone signs up use this method to save their
    # information in the db. we're not encrypting passwords.
    def self.save db, user_data
      sql = %q[INSERT INTO users (username, password) VALUES ($1, $2) RETURNING *]
      
      result = db.exec(sql, [user_data[:username], user_data[:password]])
      result.first
    end
  end
end
