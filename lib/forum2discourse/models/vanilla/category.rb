class Forum2Discourse::Models::Vanilla::Category
  include DataMapper::Resource

  storage_names[:default] = "GDN_Category"

  property :id, Serial, field: 'CategoryID'
  property :name, String, field: 'Name'
  property :description, Text, field: 'Description'
end
