class RandomPoemsController < ApplicationController
  def random_poem
    if params[:generate]
      @text = RandomPoemHelper.random_poem
    end
  end
end