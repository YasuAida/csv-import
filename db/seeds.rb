require "csv"

# coding: utf-8

CSV.foreach('db/entrypattern.txt') do |row|
    Entrypattern.create(:sku => row[0], :kind_of_transaction => row[1], :kind_of_payment => row[2], :detail_of_payment => row[3], :handling => row[4])
end

#CSV.foreach('db/journalpattern.txt') do |row|
#    Journalpattern.create(:taxcode => row[0], :ledger => row[1], :pattern => row[2], :debit_account => row[3], :debit_subaccount => row[4], :debit_taxcode => row[5], :credit_account => row[6], :credit_subaccount => row[7], :credit_taxcode => row[8])
#end

#CSV.foreach('db/account.txt') do |row|
#    Account.create(:account => row[0], :debit_credit => row[1], :bs_pl => row[2])
#end

#Currency.create!(name: '円', method: '換算無し')

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)