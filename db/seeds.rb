require "csv"

# coding: utf-8

CSV.foreach('db/pattern.txt') do |row|
    Entrypattern.create(:SKU => row[0], :kind_of_transaction => row[1], :kind_of_payment => row[2], :detail_of_payment => row[3], :handling => row[4], :debt => row[5], :credit => row[6])
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Stock.create!( date: '2016/12/1', asin: 111111, goods_name: "hogehoge", number: 1, unit_price: 120, money_paid: '2016/12/15', purchase_from: "hogehoge", currency: "hogehoge", sku: "1234345", rate: 120.23 )
Subexpense.create!( item: "hogehoge", method: "hogehoge", date: "2016/11/10", purchase_from: "jpgejpge", amount: '12.12', targetgood: "hogehoge", rate: "120.12", currency: "120" )
Stock.first.expense_relations.create!(stock_id: 1, subexpense_id: 1)