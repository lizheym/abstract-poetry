class PoemsController < ApplicationController
  def new
    @poem = Poem.new
  end

  def create
    @poem = Poem.new(params.require(:poem).permit(:title, :text))

    @poem.save
    redirect_to @poem
  end

  def show
    @poem = Poem.find(params[:id])
  end
end
