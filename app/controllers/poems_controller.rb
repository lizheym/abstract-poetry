require 'rubygems'

class PoemsController < ApplicationController
  def index
    @poems = Poem.where(:user_id => nil)
  end

  def my_poems
    @poems = Poem.where(:user_id => current_user&.id)
  end

  def new
    @poem = Poem.new
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
