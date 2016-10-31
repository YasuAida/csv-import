class Currency < ActiveRecord::Base
    validates :name, uniqueness: { scope: [:method] }, presence: true
    validates :method, presence: true
end
