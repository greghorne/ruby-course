require 'active_record'
require 'active_record_tasks'

require_relative '../lib/models/entities/shop.rb'
require_relative '../lib/models/entities/user.rb'
require_relative '../lib/models/entities/dog.rb'
require_relative '../lib/models/entities/cat.rb'

#require_relative '../lib/pet-shop-server.rb'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => 'pet_shop_server'
)