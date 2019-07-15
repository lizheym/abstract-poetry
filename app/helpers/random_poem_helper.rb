require 'nokogiri'
require 'open-uri'

module RandomPoemHelper
  def self.random_poem
    poem = ""
    10.times do
      line = self.random_line
      poem << line << "\n" if line.length < 100
    end
    poem
  end

  def self.random_line
    poem_array = random_poem_as_array
    random_line_from_array(poem_array)
  end

  def self.random_line_from_array(line_array)
    line_array.shuffle.first
  end

  def self.random_poem_as_array
    url = 'https://www.poetryoutloud.org/poems-and-performance/random-poem'

    html = open(url)
    poem_text = _get_poem_text_from_html(html)

    return [""] if poem_text.nil?

    poem_text.split(/\R+/)
  end

  private

  def self._get_poem_text_from_html(html)
    doc = Nokogiri::HTML(html)

    poem = doc&.at_css('.bodyTxt_1')
    poem_paragraph = poem&.at_css('p')
    poem_paragraph&.xpath('text()')&.text
  end
end