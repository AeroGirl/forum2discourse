require 'data_mapper'

module TestDatabase
  # XXX This will need refactoring when >1 format is used.
  TEST_DATABASE_CONNECTION_STRING = "mysql://root@127.0.0.1:3306/forum2discourse_test"

  def self.prepare
    DataMapper::Logger.new($stdout, :info)
    DataMapper.setup(:test, TEST_DATABASE_CONNECTION_STRING)
    execute_queries_from(categories_sql)
    execute_queries_from(posts_sql)
  end

  def self.execute_queries_from(sql)
    # Datamapper won't execute queries containing ';'
    categories_sql.split(';').each do |statement|
      next if statement.chomp.empty?
      begin
        DataMapper.repository(:test).adapter.execute(statement)
      rescue DataObjects::SQLError
        puts "Failed with statement: "
        puts statement.inspect
        raise
      end
    end
  end

  def self.categories_sql
    File.open("#{RSPEC_ROOT}/test_data/categories.sql", 'r') { |f| f.read }
  end

  def self.posts_sql
    File.open("#{RSPEC_ROOT}/test_data/posts.sql", 'r') { |f| f.read }
  end
end