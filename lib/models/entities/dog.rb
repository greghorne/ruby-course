module AR
  class Dog < ActiveRecord::Base
    belongs_to :shop
  end
end
