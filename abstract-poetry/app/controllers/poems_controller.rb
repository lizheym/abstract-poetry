require 'rubygems'
require 'engtagger'

PLACEHOLDER = "XXXXXX".freeze
CONTRACTIONS = "ain't amn't aren't can't cain't 'cause could've couldn't couldn't've daren't daresn't dasn't didn't doesn't don't e'er everyone's finna gimme giv’n gonna gon't gotta hadn't hasn't haven't he'd he'll he's he've how'd howdy how'll how're how's I'd I'll I'm I'm'a I'm'o I've isn't it'd it'll it's let's ma'am mayn't may've mightn't might've mustn't mustn't've must've needn't ne'er o'clock o'er ol' oughtn't 's shalln't shan't she'd she'll she's should've shouldn't shouldn't've somebody's someone's something's so're that'll that're that's that'd there'd there'll there're there's these're they'd they'll they're they've this's those're 'tis 'twas wasn't we'd we'd've we'll we're we've weren't what'd what'll what're what's what've when's where'd where're where's where've which's who'd who'd've who'll whom'st whom'st'd've who're who's who've why'd why're why's won't would've wouldn't y'all y'all'd've you'd you'll you're you've"

class PoemsController < ApplicationController
  def index
    @poems = Poem.all
  end

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

  def delete
    @poem = Poem.find(params[:poem_id])
    @poem.destroy

    redirect_to poems_path
  end

  def cycle
    config.logger = Logger.new(STDOUT)

    @poem = Poem.find(params[:poem_id])
    @cycle_num = params[:count]

    if @poem.text.presence
      tgr = EngTagger.new
      raw_text = @poem.text
      tagged = tgr.add_tags(raw_text)
      nouns_in_order = _get_nouns_in_order(tagged)
      logger.info nouns_in_order.join(", ")
      with_placeholders = _replace_nouns_with_placeholders(raw_text, nouns_in_order)
      cycled_nouns = _cycle_nouns(nouns_in_order, 1)
      text_with_nouns_cycled = _replace_placeholders_with_nouns(with_placeholders, cycled_nouns)

      @poem.update(:text => text_with_nouns_cycled)
    end

    redirect_to @poem
  end

  def shuffle
    config.logger = Logger.new(STDOUT)

    @poem = Poem.find(params[:poem_id])
    @cycle_num = params[:count]

    if @poem.text.presence
      tgr = EngTagger.new
      raw_text = @poem.text
      tagged = tgr.add_tags(raw_text)
      nouns_in_order = _get_nouns_in_order(tagged)
      logger.info nouns_in_order.join(", ")
      with_placeholders = _replace_nouns_with_placeholders(raw_text, nouns_in_order)
      shuffled_nouns = _shuffle_nouns(nouns_in_order)
      text_with_nouns_cycled = _replace_placeholders_with_nouns(with_placeholders, shuffled_nouns)

      @poem.update(:text => text_with_nouns_cycled)
    end

    redirect_to @poem
  end

  private

  def _cycle_nouns(nouns, count)
    count = -count
    nouns.rotate(count)
  end

  def _shuffle_nouns(nouns)
    nouns.shuffle
  end

  def _replace_placeholders_with_nouns(text, nouns)
    nouns.each do |noun|
      text = text.sub(PLACEHOLDER, noun)
    end
    text
  end

  def _replace_nouns_with_placeholders(text, nouns)
    nouns.each do |noun|
      text = text.sub(/\b#{noun}\b/, "#{PLACEHOLDER}")
    end
    text
  end

  def _get_nouns_in_order(tagged)
    nouns = []
    tokens = tagged.split(" ")
    tokens.each do |token|
      if _is_noun?(token)
        logger.info token
        noun = ActionView::Base.full_sanitizer.sanitize(token)
        logger.info noun
        #if the last character is puncutation, remove it
        if ["—", ".", "-", ";"].any? { |char| noun[-1] == char }
          noun = noun[0...-1]
        end
        if _is_alpha?(noun)
          nouns << noun
        end
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

  def _is_alpha?(str)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    str.chars.detect {|ch| !chars.include?(ch)}.nil?
  end
end
