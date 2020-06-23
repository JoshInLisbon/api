require 'rails_helper'

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#validations' do
    # use a # to name a group of tests which are called on the instance of an object
    # to call validations, you do Article.new.valid [instance of class]
    it 'should test that the factory is valid' do
      expect(build :article).to be_valid
    end

    it 'should validate the presence of the title' do
      article = build :article, title: ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:title]).to include("can't be blank")
    end

    it 'should validate the presence of the content' do
      article = build :article, content: ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:content]).to include("can't be blank")
    end

    it 'should validate the presence of the slug' do
      article = build :article, slug: ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:slug]).to include("can't be blank")
    end

    it 'should validate uniqueness of the slug' do
      article = create :article
      # invalid_article = FactoryBot.create :article, slug: article.slug
      # I had this line above but the test failed, that is because I could not '.create' an article
      # with an invalid slug... instead I had to '.build' it
      # This teaches me about the difference between create and build... create is trying to save it, build
      # makes the instance in a floaty way
      invalid_article = FactoryBot.build :article, slug: article.slug
      expect(invalid_article).not_to be_valid
    end
  end

  describe '.recent' do
    # Here we use a . (and not a #) because we are testing class methods
    # Class.all or Class.recent
    it 'should list recent article first' do
      old_article = create :article
      newer_article = create :article
      expect(described_class.recent).to eq(
        [newer_article, old_article]
      )
      # to make sure it works, updated created at of older and test again
      old_article.update_column :created_at, Time.now
      expect(described_class.recent).to eq(
        [old_article, newer_article]
      )

    end

    it 'should have a described_class to eq Article' do
      expect(described_class).to eq(Article)
    end
  end
end



# run with $rspec
# failed with validations
# add to article.rb

