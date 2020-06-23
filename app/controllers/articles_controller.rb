class ArticlesController < ApplicationController

  def index
    # you can return raw json to the browser:
    # render json: 'hello'
    # render json: {} # to pass the status 200 test
    # # articles = Article.all
    # want to update to make the articles appear in order
    # I want to be able to run Article.recent
    # # articles = Article.recent
    # but there is no recent method for Article
    # before I make it... I'm going to do TDD, so build a test
    # so write a model test

    # with Kaminari
    articles = Article.recent.
      page(params[:page]).
      per(params[:per_page])
      # when you run you get []... and pagination links on index
      # (empty because test db not same as develop db)
    render json: articles
  end

  def show
    render json: Article.find(params[:id])
  end

end
