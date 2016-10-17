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
