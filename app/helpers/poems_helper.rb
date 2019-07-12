require 'engtagger'
require 'nokogiri'
require 'open-uri'

module PoemsHelper
  PLACEHOLDER = "XXXXXX".freeze
  NOUN_LIST = ["NN", "NNP", "NNS", "NNPS"].freeze
  ADJECTIVE_LIST = ["JJ", "JJR", "JJS"].freeze

  def self.cycle_adjectives_in_text(text)
    adjectives_in_order = self.get_adjectives_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, adjectives_in_order)
    cycled_adjectives = self.cycle_array(adjectives_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, cycled_adjectives)

    self.fix_articles(text)
  end

  def self.shuffle_adjectives_in_text(text)
    adjectives_in_order = self.get_adjectives_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, adjectives_in_order)
    shuffled_adjectives = self.shuffle_array(adjectives_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, shuffled_adjectives)

    self.fix_articles(text)
  end

  def self.cycle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    cycled_nouns = self.cycle_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, cycled_nouns)

    self.fix_articles(text)
  end

  def self.shuffle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    shuffled_nouns = self.shuffle_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, shuffled_nouns)

    self.fix_articles(text)
  end

  def self.cycle_lines_in_text(text)
    text = text.gsub("\r\n\r\n", "\r\n \r\n") # Preserve empty lines
    split_by_lines = text.split("\r\n")
    cycled_lines = cycle_array(split_by_lines)
    cycled_lines.join("\r\n").concat("\r\n")
  end

  def self.shuffle_lines_in_text(text)
    text = text.gsub("\r\n\r\n", "\r\n \r\n") # Preserve empty lines
    split_by_lines = text.split("\r\n")
    shuffled_lines = shuffle_array(split_by_lines)
    shuffled_lines.join("\r\n").concat("\r\n")
  end

  def self.fix_articles(text)
    articles_in_order = self.get_articles_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, articles_in_order)
    correct_articles = self.get_correct_articles(text)
    text = self.replace_placeholders_with_words(with_placeholders, correct_articles)
  end

  def self.cycle_array(nouns)
    nouns.rotate(-1)
  end

  def self.shuffle_array(nouns)
    nouns.shuffle
  end

  def self.replace_placeholders_with_words(text, nouns)
    nouns.each do |noun|
      text = text.sub(PLACEHOLDER, noun)
    end
    text
  end

  def self.replace_words_with_placeholders(text, nouns)
    nouns.each do |noun|
      text = text.sub(/\b#{noun}\b/, "#{PLACEHOLDER}")
    end
    text
  end

  def self.get_nouns_in_order(raw_text)
    tgr = EngTagger.new
    tagged = tgr.add_tags(raw_text)
    nouns = []
    tokens = tagged.split(" ")

    tokens.each do |token|
      if self.is_noun?(token)
        noun = ActionView::Base.full_sanitizer.sanitize(token)

        #if the last character is puncutation, remove it
        if ["—", ".", "-", ";"].any? { |char| noun[-1] == char }
          noun = noun[0...-1]
        end

        if self.is_alpha?(noun)
          nouns << noun
        end
      end
    end
    nouns
  end

  def self.get_adjectives_in_order(raw_text)
    tgr = EngTagger.new
    tagged = tgr.add_tags(raw_text)
    adjectives = []
    tokens = tagged.split(" ")

    tokens.each do |token|
      if self.is_adjective?(token)
        adjective = ActionView::Base.full_sanitizer.sanitize(token)

        #if the last character is puncutation, remove it
        if ["—", ".", "-", ";"].any? { |char| adjective[-1] == char }
          adjective = adjective[0...-1]
        end

        if self.is_alpha?(adjective)
          adjectives << adjective
        end
      end
    end
    adjectives
  end

  def self.get_adjectives(string)
    tgr = EngTagger.new
    tagged = tgr.add_tags(string)
    tgr.get_adjectives(tagged)
  end

  def self.get_articles_in_order(string)
    words = string.split(/\W+/)

    words.select { |word| ["A", "An", "a", "an"].include?(word) }
  end

  def self.get_correct_articles(string)
    words = string.split(/\W+/)

    words.each_with_index.map do |word, index|
      if ["A", "An"].include?(word)
        if "aeiouAEIOU".chars.include?(words[index + 1][0])
          "An"
        else
          "A"
        end
      elsif ["a", "an"].include?(word)
        if "aeiouAEIOU".chars.include?(words[index + 1][0])
          "an"
        else
          "a"
        end
      end
    end.compact
  end

  def self.is_noun?(token)
    token.match?(/<nn>.*<\/nn>/) || token.match?(/<nnp>.*<\/nnp>/) || token.match?(/<nnps>.*<\/nnps>/) || token.match?(/<nns>.*<\/nns>/)
  end

  def self.is_adjective?(token)
    token.match?(/<jj>.*<\/jj>/) || token.match?(/<jjr>.*<\/jjr>/) || token.match?(/<jjs>.*<\/jjs>/)
  end

  def self.is_alpha?(string)
    string.match?(/^[[:alpha:]]+$/)
  end

  def self.random_poem
    poem = ""
    10.times do
      line = self.random_line
      poem << line << "\n" if line.length < 100
    end
    poem
  end

  def self.random_line
    random_url = 'https://www.poetryoutloud.org/poems-and-performance/random-poem'

    html = open(random_url)
    doc = Nokogiri::HTML(html)

    poem = doc&.at_css('.bodyTxt_1')
    poem_paragraph = poem&.at_css('p')
    poem_text = poem_paragraph&.xpath('text()')&.text

    return "" if poem_text.nil?

    poem_text.split(/\R+/).shuffle.first
  end
end
