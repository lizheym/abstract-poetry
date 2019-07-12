class RandomPoemsController < ApplicationController
  def random_poem
    if params[:generate]
      @text = PoemsHelper.random_poem
    end
  end
end