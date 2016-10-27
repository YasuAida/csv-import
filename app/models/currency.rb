class Currency < ActiveRecord::Base
    validates :name, uniqueness: { scope: [:method] }
end
