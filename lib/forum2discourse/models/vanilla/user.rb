class Forum2Discourse::Models::Vanilla::User
  include DataMapper::Resource

  storage_names[:default] = "GDN_User"

  property :id, Serial, field: "UserID"
  property :username, String, field: "Name"
  property :email,      String, field: "Email"
  property :ip_address,      String, field: "LastIPAddress"

  def to_discourse
    Forum2Discourse::Models::Discourse::User.new(
      username: username,
      email: email,
      ip_address: ip_address,
    )
  end
end
