require 'rubygems'
require 'engtagger'

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

  def cycle
    @poem = Poem.find(params[:poem_id])
    @cycle_num = params[:count]

    tgr = EngTagger.new
    raw_text = @poem.text
    tagged = tgr.add_tags(raw_text)
    nouns_in_order = _get_nouns_in_order(tagged)
    with_placeholders = _replace_nouns_with_placeholders(raw_text, nouns_in_order)
    cycled_nouns = _cycle_nouns(nouns_in_order, 1)
    text_with_nouns_cycled = _replace_placeholders_with_nouns(with_placeholders, cycled_nouns)

    @poem.update(:text => text_with_nouns_cycled)

    redirect_to @poem
  end

  private

  def _cycle_nouns(nouns, count)
    count = -count
    nouns.rotate(count)
  end

  def _replace_placeholders_with_nouns(text, nouns)
    nouns.each do |noun|
      text = text.sub("XXXXXX", "<strong>" + noun + "</strong>")
    end
    text
  end

  def _replace_nouns_with_placeholders(text, nouns)
    nouns.each do |noun|
      text = text.sub(noun, "XXXXXX")
    end
    text
  end

  def _get_nouns_in_order(tagged)
    nouns = []
    tokens = tagged.split(" ")
    tokens.each do |token|
      if _is_noun?(token)
        nouns << ActionView::Base.full_sanitizer.sanitize(token)
      end
    end
    nouns
  end

  def _is_noun?(token)
    token.match(/<nn>.*<\/nn>/) || token.match(/<nnp>.*<\/nnp>/) || token.match(/<nnps>.*<\/nnps>/) || token.match(/<nns>.*<\/nns>/)
  end

  def _remove_tags(tagged)
    ActionView::Base.full_sanitizer.sanitize(tagged)
  end
end
