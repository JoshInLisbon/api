require 'rails_helper'

describe ArticlesController do
  # we have tests for each controller action, so we make descriptions for each section
  describe '#index' do
    subject { get :index }

    it 'should return correct http success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    # it 'should return proper json which matches the jsonapi.org standard' do
    #   # FactoryBot command:
    #   create_list :article, 2 # but this fails, as slugs must be unique, and this creates duplicates
    #   # to fix this we need to update the factory (in spec we have a factories folder with an articles.rb file...
    #   # if we use rails g model to make a model, it makes a facotry folder)
    #   get :index
    #   json = JSON.parse(response.body)
    #   # pp json
    #   # returning
    #   # [{"id"=>1,
    #   #   "title"=>"My awesome article 1",
    #   #   "content"=>"MyText content 1",
    #   #   "slug"=>"my-slug-1",
    #   #   "created_at"=>"2020-06-22T12:55:05.976Z",
    #   #   "updated_at"=>"2020-06-22T12:55:05.976Z"},
    #   #  {"id"=>2,
    #   #   "title"=>"My awesome article 2",
    #   #   "content"=>"MyText content 2",
    #   #   "slug"=>"my-slug-2",
    #   #   "created_at"=>"2020-06-22T12:55:05.981Z",
    #   #   "updated_at"=>"2020-06-22T12:55:05.981Z"}]
    #   # but we don't want all the details (id, created_at, updated_at) - given all of these because Rails uses
    #   # default active model adapter to translate models to json
    #   # use active_model_serializers jem... turns things to json and allows managment of attributes easily
    #   # 1. add to gemfile, 2. rails g serializer article [+ list of attributes json should contain] title content slug [automatically includes id]
    #   # now we get:
    #   # [{"id"=>1,
    #   #   "title"=>"My awesome article 1",
    #   #   "content"=>"MyText content 1",
    #   #   "slug"=>"my-slug-1"},
    #   #  {"id"=>2,
    #   #   "title"=>"My awesome article 2",
    #   #   "content"=>"MyText content 2",
    #   #   "slug"=>"my-slug-2"}]
    #   # but still not matching our required format (jsonapi.org)...
    #   # {
    #   #   "data": {
    #   #     "type": "articles",
    #   #     "id": "1",
    #   #     "attributes": {
    #   #       // ... this article's attributes
    #   #     },
    #   # to solve this...
    #   # 1. make an initializer ... config/initializerz/active_model_serializers.rb
    #   # runs when web app starts, whatever is in file is executed on server restart,
    #   # need to replace standard ActiveModelSerializers.config.adapter to the :json_api vs default
    #   json_data = json['data']
    #   expect(json_data.length).to eq(2)
    #   expect(json_data[0]['attributes']).to eq({
    #     "title"=>"My awesome article 1",
    #     "content"=>"MyText content 1",
    #     "slug"=>"my-slug-1"
    #   })
    #   expect(json_data[1]['attributes']).to eq({
    #     "title"=>"My awesome article 2",
    #     "content"=>"MyText content 2",
    #     "slug"=>"my-slug-2"
    #   })
    #   # problem is that this test does not scale... I need to refactor it to make it dynamic
    #   # right now we are serving 'render json: {}', so this fails... need to change what we serve in controller
    #   # ALERT
    #   # the gem we use in this is not monitored any more
    #   # https://driggl.com/blog/a/from-activemodel-serializers-to-fast-jsonapi this is a new one!
    # end

    it '[Refactor - reusable, less static info inside] should return proper json which matches the jsonapi.org standard' do
      create_list :article, 2
      # this just makes a list, which can be pulled with Article.all or Article.recent

      # sending requests

      # get :index
      subject
      # this is going to happen in all of our tests inside '#index'
      # RSpec does not want you to be repeating code for no reason, so there is a 'subject' method
      # you call it at the start of every method
      # you can see how it makes the code easier to read too... as the start of the testing is:
      # describe '#index' do
      #   subject { get: index }
      # so you know what this block is about

      # json variables

      # json = JSON.parse(response.body)
      # json_data = json['data']

      # we will use these in lots of tests... so we can extract them to a helper in all spec files
      # create new folder in spec directory called support (code to be avialable for all tests, not laoded by default but we can change that)
      # now I can comment out the two json lines


      # 1. remove length check
      # expect(json_data.length).to eq(2)
      # 2. add loop
      Article.recent.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq({
          # make content dynamic
          "title"=> article.title,
          "content"=> article.content,
          "slug"=> article.slug
        })
      end
    end

    it 'should return articles in the propper order' do
      old_article = create :article
      newer_article = create :article
      subject
      expect(json_data.first['id']).to eq(newer_article.id.to_s)
      expect(json_data.last['id']).to eq(old_article.id.to_s)
    end

    it 'should paginate results' do
      create_list :article, 3
      get :index, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq 1
      expected_article = Article.recent.second.id.to_s
      expect(json_data.first['id']).to eq(expected_article)
      # we will use gem 'kaminari'
    end

    it 'should have a described_class to eq ArticlesController' do
      expect(described_class).to eq(ArticlesController)
    end
  end

  describe '#show' do
    # subject { get :show }
    # this was wrong... because show needs a paramter... it needs to know which item to show
    let(:article) { create :article }
    # Use let to define a memoized helper method. The value will be cached
    # across multiple calls in the same example but not across examples.
    # Note that let is lazy-evaluated: it is not evaluated until the first time
    # the method it defines is invoked. You can use let! to force the method's
    # invocation before each example.
    subject { get :show, params: { id: article.id } }

    it 'should return ok htttp response' do
      # article = create :article
      subject
      expect(response).to have_http_status(:ok)
      # this
    end

    it 'should respond in correct jsonapi.org format' do
      subject
      expect(json_data['attributes']).to eq({
        "title"=> article.title,
        "content"=> article.content,
        "slug"=> article.slug
      })
    end
  end
end
