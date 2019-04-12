require 'open-nlp'

module PoemsHelper
  PLACEHOLDER = "XXXXXX".freeze

  def self.cycle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_nouns_with_placeholders(text, nouns_in_order)
    cycled_nouns = self.cycle_noun_array(nouns_in_order)
    self.replace_placeholders_with_nouns(with_placeholders, cycled_nouns)
  end

  def self.shuffle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_nouns_with_placeholders(text, nouns_in_order)
    shuffled_nouns = self.shuffle_noun_array(nouns_in_order)
    self.replace_placeholders_with_nouns(with_placeholders, shuffled_nouns)
  end

  def self.cycle_noun_array(nouns)
    nouns.rotate(-1)
  end

  def self.shuffle_noun_array(nouns)
    nouns.shuffle
  end

  def self.replace_placeholders_with_nouns(text, nouns)
    nouns.each do |noun|
      text = text.sub(PLACEHOLDER, noun)
    end
    text
  end

  def self.replace_nouns_with_placeholders(text, nouns)
    nouns.each do |noun|
      text = text.sub(/\b#{noun}\b/, "#{PLACEHOLDER}")
    end
    text
  end

  def self.get_nouns_in_order(string)
    OpenNLP.load
    tokenizer = OpenNLP::TokenizerME.new
    tagger = OpenNLP::POSTaggerME.new

    tokens = tokenizer.tokenize(string).to_a
    tokens = tokens.map { |word| word.split("-") }.flatten # dash
    tokens = tokens.map { |word| word.split("—") }.flatten # em dash
    tokens = tokens.map { |word| word.split(".") }.flatten # em dash

    tags = tagger.tag(tokens).to_a

    tokens.select.with_index { |token, index| ["NN", "NNP", "NNS"].include?(tags[index]) && is_alpha?(token) }
  end

  def self.is_alpha?(string)
    string.match?(/^[[:alpha:]]+$/)
  end
end
