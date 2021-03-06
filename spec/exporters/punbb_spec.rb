require 'spec_helper'
require 'test_database'
require 'forum2discourse'
require 'pry'

describe Forum2Discourse::Exporters::PunBB do
  before do
    TestDatabase.prepare
    # Ensure punbb is included in registry as prior tests could have removed it
    Forum2Discourse::Exporter.clear_registry
    Forum2Discourse::Exporter.register(:punbb, Forum2Discourse::Exporters::PunBB)
  end

  let(:exporter) { Forum2Discourse::Exporter.create(:punbb, connection_string: 'mysql://root@127.0.0.1:3306/forum2discourse_test') }
  # Unsure as to tying this to the test schema so tightly...
  describe "#topics" do
    let(:first_topic_posts) do
      [
          Forum2Discourse::Models::Discourse::Post.new(
            {title: '', raw: 'Test Message', created_at: Time.new(2004,11,19,13,59,55), category: 'Forum One'},
          ),
          Forum2Discourse::Models::Discourse::Post.new(
            {title: '', raw: 'Test Message 2', created_at: Time.new(2004,11,19,15,21,38), category: 'Forum One'}
          )
      ]
    end

    let(:deep_topic) do
      # Deep representation of a single topic
      Forum2Discourse::Models::Discourse::Topic.new({
        category: 'Forum One',
        created_at: Time.new(2004,11,15,16,07,23), 
        title: 'Test Topic'
      })
    end

    let(:first_topic) { exporter.topics(order: [:id.asc]).first }
    let(:second_topic) { exporter.topics(order: [:id.asc], offset: 1, limit: 1).first }
    let(:faked_user) { Forum2Discourse::Models::Discourse::User.new(username: 'Peter Stringfel', name: 'Peter Stringfellow', email: 'Peter Stringfellow.no.email@example.com.invalid') } 

    it 'returns an Array of Forum2Discourse::Models::Discourse::Topic' do
      expect(exporter.topics).to be_kind_of(Array)
      exporter.topics.each do |item|
        expect(item).to be_kind_of(Forum2Discourse::Models::Discourse::Topic)
      end
    end

    it 'returns the correct number of topics' do
      expect(exporter.topics).to have(2).items
    end

    it 'returns topics with correct categories' do
      expect(exporter.topics.map(&:category)).to eq(['Forum One', 'Forum Two'])
    end

    it 'returns the correct topic data' do
      expect(first_topic.serialize).to eq(deep_topic.serialize)
    end

    it 'returns the correct posts for a topic' do
      expect(first_topic.posts.map(&:serialize)).to eq(first_topic_posts.map(&:serialize))
    end
    
    # Lol, demeter.
    it 'provides the correct user for a topic' do
      test_user = Forum2Discourse::Models::Discourse::User.new({
        username: 'gclooney',
        name: 'George Clooney',
        email: 'george@example.com'
      })
      expect(first_topic.posts.first.user.serialize).to eq(test_user.serialize)
    end

    it 'provides an approximation of a user if no corresponding user was found' do
      expect(second_topic.posts.first.user.serialize).to eq(faked_user.serialize) 
    end
  end
end
