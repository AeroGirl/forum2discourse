class Forum2Discourse::Models::Discourse::Topic < Forum2Discourse::Models::Discourse::Base
  # Standard attrs
  attr_accessor :title, :category

  # User attrs
  attr_accessor :user_id, :last_post_user_id

  # Time attrs
  attr_accessor :created_at

  # Need to figure out what these are
  attr_accessor :archetype, :subtype, :meta_data

  # Relationships
  attr_accessor :posts

  def initialize(attrs)
    super
    @posts = []
  end

  def serialize
    super.merge(posts: posts)
  end
end
