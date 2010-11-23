class CreateVerses < ActiveRecord::Migration
  def self.up
    db = ActiveRecord::Base.connection.instance_variable_get('@config')[:database]
    system("mysql -u root #{db} < #{RAILS_ROOT}/db/avkjv.sql")
  end

  def self.down
    drop_table :verses
    drop_table :books
  end
end
