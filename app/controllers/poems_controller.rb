require 'rubygems'

class PoemsController < ApplicationController
  def index
    @poems = Poem.where(:user_id => nil).or(Poem.where(:public => true)).order(:updated_at => :desc)
  end

  def my_poems
    @poems = Poem.where(:user_id => current_user&.id).order(:updated_at => :desc)
  end

  def new
    @poem = Poem.new(params.permit(:title, :text))
  end

  def create
    @poem = Poem.new(params.require(:poem).permit(:title, :text).merge(:user_id => current_user&.id))
    @poem.update(:original => @poem.text)

    @poem.save
    redirect_to @poem
  end

  def show
    @poem = Poem.find(params[:id])
  end

  def delete
    @poem = Poem.find(params[:poem_id])
    @poem.destroy

    redirect_to poems_path
  end

  def toggle_public
    @poem = Poem.find(params[:poem_id])
    @poem.update(:public => !@poem.public)

    @poem.save
    redirect_to @poem
  end

  def cycle_nouns
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.cycle_nouns_in_text(@poem.text))
    end

    redirect_to @poem
  end

  def shuffle_nouns
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.shuffle_nouns_in_text(@poem.text))
    end

    redirect_to @poem
  end

  def cycle_adjectives
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.cycle_adjectives_in_text(@poem.text))
    end

    redirect_to @poem
  end

  def shuffle_adjectives
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.shuffle_adjectives_in_text(@poem.text))
    end

    redirect_to @poem
  end

  def cycle_lines
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.cycle_lines_in_text(@poem.text))
    end

    redirect_to @poem
  end

  def shuffle_lines
    @poem = Poem.find(params[:poem_id])

    if @poem.text.presence
      @poem.update(:text => PoemsHelper.shuffle_lines_in_text(@poem.text))
    end

    redirect_to @poem
  end
end
