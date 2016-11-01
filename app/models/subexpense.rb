class Subexpense < ActiveRecord::Base
    validates :item, uniqueness: { scope: [:method, :date, :purchase_from, :amount, :targetgood] }, presence: true
    validates :method, presence: true
    validates :date, presence: true
    validates :purchase_from, presence: true
    validates :amount, presence: true
    validates :targetgood, presence: true
    
    has_many :expense_relations, dependent: :destroy
    has_many :expense_relation_stocks, through: :expense_relations, source: :stock
end
