require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    if included?(@word.upcase, params[:letters])
      if english_word?(@word)
        @result = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @result = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@word.upcase} can't be built out of #{new.join(', ')}"
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
