require 'open-nlp'

module PoemsHelper
  PLACEHOLDER = "XXXXXX".freeze
  NOUN_LIST = ["NN", "NNP", "NNS", "NNPS"].freeze
  ADJECTIVE_LIST = ["JJ", "JJR", "JJS"].freeze

  def self.cycle_adjectives_in_text(text)
    adjectives_in_order = self.get_words_in_order_by_part_of_speech(text, ADJECTIVE_LIST)
    with_placeholders = self.replace_words_with_placeholders(text, adjectives_in_order)
    cycled_adjectives = self.cycle_array(adjectives_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, cycled_adjectives)

    self.fix_articles(text)
  end

  def self.shuffle_adjectives_in_text(text)
    adjectives_in_order = self.get_words_in_order_by_part_of_speech(text, ADJECTIVE_LIST)
    with_placeholders = self.replace_words_with_placeholders(text, adjectives_in_order)
    shuffled_adjectives = self.shuffle_array(adjectives_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, shuffled_adjectives)

    self.fix_articles(text)
  end

  def self.cycle_nouns_in_text(text)
    nouns_in_order = self.get_words_in_order_by_part_of_speech(text, NOUN_LIST)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    cycled_nouns = self.cycle_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, cycled_nouns)

    self.fix_articles(text)
  end

  def self.shuffle_nouns_in_text(text)
    nouns_in_order = self.get_words_in_order_by_part_of_speech(text, NOUN_LIST)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    shuffled_nouns = self.shuffle_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, shuffled_nouns)

    self.fix_articles(text)
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

  def self.get_words_in_order_by_part_of_speech(string, parts_of_speech)
    OpenNLP.load
    tokenizer = OpenNLP::TokenizerME.new
    tagger = OpenNLP::POSTaggerME.new

    tokens = tokenizer.tokenize(string).to_a
    tokens = tokens.map { |word| word.split("-") }.flatten # dash
    tokens = tokens.map { |word| word.split("—") }.flatten # em dash
    tokens = tokens.map { |word| word.split(".") }.flatten # em dash

    tags = tagger.tag(tokens).to_a

    tokens.select.with_index { |token, index| parts_of_speech.include?(tags[index]) && is_alpha?(token) }
  end

  def self.get_articles_in_order(string)
    OpenNLP.load
    tokenizer = OpenNLP::TokenizerME.new

    tokens = tokenizer.tokenize(string).to_a

    tokens.select { |token| ["A", "An", "a", "an"].include?(token) }
  end

  def self.get_correct_articles(string)
    OpenNLP.load
    tokenizer = OpenNLP::TokenizerME.new

    tokens = tokenizer.tokenize(string).to_a

    tokens.each_with_index.map do |token, index|
      if ["A", "An"].include?(token)
        if "aeiouAEIOU".chars.include?(tokens[index + 1][0])
          "An"
        else
          "A"
        end
      elsif ["a", "an"].include?(token)
        if "aeiouAEIOU".chars.include?(tokens[index + 1][0])
          "an"
        else
          "a"
        end
      end
    end.compact
  end

  def self.is_alpha?(string)
    string.match?(/^[[:alpha:]]+$/)
  end
end
