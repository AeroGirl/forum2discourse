class Forum2Discourse::Models::Vanilla::User
  include DataMapper::Resource

  storage_names[:default] = "LUM_User"

  property :id, Serial, field: "UserID"
  property :username, String, field: "Name"
  property :email,      String, field: "Email"

  def to_discourse
    Forum2Discourse::Models::Discourse::User.new(
      username: username,
      email: email
    )
  end
end
