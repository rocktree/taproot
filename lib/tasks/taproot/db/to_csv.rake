require 'fileutils'
require 'csv'

namespace :taproot do
  namespace :db do

    desc 'Backup database to ruby hashes'
    task :to_csv => :environment do
      backup_dir = Rails.root.join('db','backups','csv')
      FileUtils.mkdir_p(backup_dir)
      ActiveRecord::Base.connection.tables.each do |table|
        begin
          model = table.classify.constantize
          CSV.open("#{backup_dir}/#{model.table_name}.csv", "wb") do |csv|
            csv << model.column_names
            model.all.each do |item|
              csv << item.attributes.values
            end
          end
        rescue
        end
      end
    end

  end
end
