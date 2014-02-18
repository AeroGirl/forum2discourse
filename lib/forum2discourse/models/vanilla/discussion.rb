class Forum2Discourse::Models::Vanilla::Discussion
  include DataMapper::Resource

  storage_names[:default] = 'GDN_Discussion'

  property :id,           Serial, field: 'DiscussionID'
  property :created_at,   DateTime, field: 'DateInserted'
  property :category_id,  Integer, field: 'CategoryID'
  property :subject,      Text, field: 'Name'
  property :body, Text, field: 'Body'
  property :user_id, Integer, field: 'InsertUserID'

  has n, :comments, 'Forum2Discourse::Models::Vanilla::Comment'
  belongs_to :category, 'Forum2Discourse::Models::Vanilla::Category'

  def to_discourse
    return nil if category.nil?

    topic_comment = Forum2Discourse::Models::Vanilla::Comment.new(
      created_at: created_at,
      discussion_id: id,
      user_id: user_id,
      body: body)

    posts = comments.map(&:to_discourse)
    posts.unshift(topic_comment.to_discourse)

    Forum2Discourse::Models::Discourse::Topic.new({
      id: id,
      title: subject,
      created_at: created_at,
      category: category.name,
      posts: posts
    })
  end
end
