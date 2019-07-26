class SearchTweetsController < ApplicationController

  def index
    @hashtags = {}
    @hashtags.default = 0
    @top_hashtags = {}
    @found_tweets = []
    @query = search_params[:query]

    if @query.present?
      @found_tweets = CLIENT.search(@query, result_type: search_params[:result_type],
                                   since: since_date, until: until_date).take(100)
      collect_hashtags
      hash_get_top_hashtags
    end
  end


  private

  def since_date
    (Time.now - 24.hours).strftime("%Y-%m-%d")
  end

  def until_date
    Time.now.strftime("%Y-%m-%d")
  end

  def search_params
    params.permit(:query, :result_type)
  end

  def collect_hashtags
    @found_tweets.each do |tweet|
      if tweet.hashtags?
        tweet.hashtags.each { |hashtag| @hashtags[hashtag.text] += 1 }
      end
    end
  end

  def hash_get_top_hashtags(top=10)
    @top_hashtags = @hashtags.sort_by(&:last).reverse.take(top).to_h
  end
end
