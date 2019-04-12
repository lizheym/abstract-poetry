require 'open-nlp'

module PoemsHelper
  PLACEHOLDER = "XXXXXX".freeze

  def self.cycle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    cycled_nouns = self.cycle_noun_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, cycled_nouns)

    self.fix_articles(text)
  end

  def self.shuffle_nouns_in_text(text)
    nouns_in_order = self.get_nouns_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, nouns_in_order)
    shuffled_nouns = self.shuffle_noun_array(nouns_in_order)
    text = self.replace_placeholders_with_words(with_placeholders, shuffled_nouns)

    self.fix_articles(text)
  end

  def self.fix_articles(text)
    articles_in_order = self.get_articles_in_order(text)
    with_placeholders = self.replace_words_with_placeholders(text, articles_in_order)
    correct_articles = self.get_correct_articles(text)
    text = self.replace_placeholders_with_words(with_placeholders, correct_articles)
  end

  def self.cycle_noun_array(nouns)
    nouns.rotate(-1)
  end

  def self.shuffle_noun_array(nouns)
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

  def self.get_nouns_in_order(string)
    OpenNLP.load
    tokenizer = OpenNLP::TokenizerME.new
    tagger = OpenNLP::POSTaggerME.new

    tokens = tokenizer.tokenize(string).to_a
    tokens = tokens.map { |word| word.split("-") }.flatten # dash
    tokens = tokens.map { |word| word.split("—") }.flatten # em dash
    tokens = tokens.map { |word| word.split(".") }.flatten # em dash

    tags = tagger.tag(tokens).to_a

    tokens.select.with_index { |token, index| ["NN", "NNP", "NNS", "NNPS"].include?(tags[index]) && is_alpha?(token) }
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
