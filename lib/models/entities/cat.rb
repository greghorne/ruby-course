module AR
  class Cat < ActiveRecord::Base
    belongs_to :shop
  end
end