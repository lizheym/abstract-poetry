require 'test_helper'

class PoemsHelperTest < ActionDispatch::IntegrationTest
  RSpec.describe 'PoemsHelper' do
    describe ".cycle_nouns_in_text" do
      context "with no nouns" do
        it "is the original text" do
          expect(PoemsHelper.cycle_nouns_in_text("Pretty, purple, and small")).to eq("Pretty, purple, and small")
        end
      end

      context "with nouns" do
        context "with a dash" do
          it "cycles the nouns" do
            expect(PoemsHelper.cycle_nouns_in_text("I like the crazy-lady with the hair")).to eq("I like the crazy-hair with the lady")
          end
        end

        context "with punctuation" do
          it "cycles the nouns" do
            expect(PoemsHelper.cycle_nouns_in_text("I wish I were a witch... But I'm a mermaid")).to eq("I wish I were a mermaid... But I'm a witch")
          end
        end

        context "with a repeated noun" do
          it "cycles the nouns" do
            expect(PoemsHelper.cycle_nouns_in_text("The dog and the cat are friends. I like my dog.")).to eq("The dog and the dog are cat. I like my friends.")
          end
        end
      end
    end

    describe ".cycle_array" do
      it "moves each element forward one position" do
        expect(PoemsHelper.cycle_array(["a", "b", "c"])).to eq(["c", "a", "b"])
      end
    end

    describe ".cycle_lines_in_text" do
      let(:result) { PoemsHelper.cycle_lines_in_text(text) }
      context "with a single line" do
        let(:text) { "I was a lonely teenage broncin buck\r\n" }
        it "is the original line" do
          expect(result).to eq(text)
        end
      end

      context "with a blank line" do
        let(:text) { "With a pink carnation\r\n\r\nAnd a pickup truck\r\n" }
        it "cycles the lines, incuding the blank line" do
          expect(result).to eq("And a pickup truck\r\nWith a pink carnation\r\n \r\n")
        end
      end

      context "with multiple lines" do
        let(:text) { "And I knew I was out of luck\r\nThe day\r\nThe music died\r\n" }
        it "cycles the lines" do
          expect(result).to eq("The music died\r\nAnd I knew I was out of luck\r\nThe day\r\n")
        end
      end
    end

    describe ".fix_articles" do
      context "with no articles" do
        it "is empty" do
          expect(PoemsHelper.fix_articles("I love apples")).to eq("I love apples")
        end
      end

      context "with the correct articles" do
        it "is the articles" do
          expect(PoemsHelper.fix_articles("An apple a day")).to eq("An apple a day")
        end
      end

      context "with partially correct articles" do
        it "is the correct articles" do
          expect(PoemsHelper.fix_articles("A apple a day")).to eq("An apple a day")
        end
      end

      context "with incorrect articles" do
        it "is the correct articles" do
          expect(PoemsHelper.fix_articles("A apple an day")).to eq("An apple a day")
        end
      end
    end

    describe ".replace_placeholders_with_words" do
      context "with no nouns" do
        it "returns the original text" do
          expect(PoemsHelper.replace_placeholders_with_words("Pretty pretty pretty", [])).to eq("Pretty pretty pretty")
        end
      end

      context "with a noun" do
        it "returns the text with the noun replaced" do
          expect(PoemsHelper.replace_placeholders_with_words("A good #{PoemsHelper::PLACEHOLDER}", ["doggie"])).to eq("A good doggie")
        end
      end

      context "with a multiple nouns" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_placeholders_with_words("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}", ["doggie", "kittie"])).to eq("A good doggie and kittie")
        end
      end

      context "with a repeated noun" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_placeholders_with_words("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}", ["doggie", "doggie"])).to eq("A good doggie and doggie")
        end
      end
    end

    describe ".replace_words_with_placeholders" do
      context "with no nouns" do
        it "returns the original text" do
          expect(PoemsHelper.replace_words_with_placeholders("Pretty pretty pretty", [])).to eq("Pretty pretty pretty")
        end
      end

      context "with a noun" do
        it "returns the text with the noun replaced" do
          expect(PoemsHelper.replace_words_with_placeholders("A good doggie", ["doggie"])).to eq("A good #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a multiple nouns" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_words_with_placeholders("A good doggie and kittie", ["doggie", "kittie"])).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a repeated noun" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_words_with_placeholders("A good doggie and doggie", ["doggie", "doggie"])).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end
    end

    describe ".get_words_in_order_by_part_of_speech" do
      context "nouns" do
        context "with a simple sentence" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("I gave my dog a gift for the holiday.", PoemsHelper::NOUN_LIST)).to eq(["dog", "gift", "holiday"])
          end
        end

        context "with proper nouns" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("I gave Katie a gift for the holiday.", PoemsHelper::NOUN_LIST)).to eq(["Katie", "gift", "holiday"])
          end
        end

        context "with multiple sentences" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("I gave Katie a gift for the holiday. She liked the shirt I gave her, but she wished it were a computer.", PoemsHelper::NOUN_LIST)).to eq(["Katie", "gift", "holiday", "shirt", "computer"])
          end
        end

        context "with a repeated noun" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("I love my cat. What a good cat.", PoemsHelper::NOUN_LIST)).to eq(["cat", "cat"])
          end
        end

        context "with an em dash" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("Birds fly quickly—birds with wings.", PoemsHelper::NOUN_LIST)).to eq(["Birds", "birds", "wings"])
          end
        end

        context "with a dash" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("Like quick-silver.", PoemsHelper::NOUN_LIST)).to eq(["silver"])
          end
        end

        context "with a semicolon" do
          it "returns the nouns in order" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("I like my birds; they have wings.", PoemsHelper::NOUN_LIST)).to eq(["birds", "wings"])
          end
        end

        context "with a quotation mark" do
          it "doesn't include the noun enclosed in quotes" do
            expect(PoemsHelper.get_words_in_order_by_part_of_speech("Birds say \"dog.\"", PoemsHelper::NOUN_LIST)).to eq(["Birds"])
          end
        end
      end
    end

    describe ".get_articles_in_order" do
      context "with no articles" do
        it "is empty" do
          expect(PoemsHelper.get_articles_in_order("I love apples")).to eq([])
        end
      end

      context "with articles" do
        it "is the articles in order" do
          expect(PoemsHelper.get_articles_in_order("An apple a day")).to eq(["An", "a"])
        end
      end
    end

    describe ".get_correct_articles" do
      context "with no articles" do
        it "is empty" do
          expect(PoemsHelper.get_correct_articles("I love apples")).to eq([])
        end
      end

      context "with the correct articles" do
        it "is the articles" do
          expect(PoemsHelper.get_correct_articles("An apple a day")).to eq(["An", "a"])
        end
      end

      context "with partially correct articles" do
        it "is the correct articles" do
          expect(PoemsHelper.get_correct_articles("A apple a day")).to eq(["An", "a"])
        end
      end

      context "with incorrect articles" do
        it "is the correct articles" do
          expect(PoemsHelper.get_correct_articles("A apple an day")).to eq(["An", "a"])
        end
      end
    end

    describe ".is_alpha?" do
      context "with all lowercase letters" do
        it "is true" do
          expect(PoemsHelper.is_alpha?("abcd")).to be true
        end
      end

      context " with uppercase and lowercase letters" do
        it "is true" do
          expect(PoemsHelper.is_alpha?("abcdABCD")).to be true
        end
      end

      context "with spaces" do
        it "is false" do
          expect(PoemsHelper.is_alpha?("abcd ABCD")).to be false
        end
      end

      context "with special characters" do
        it "is false" do
          expect(PoemsHelper.is_alpha?("abcdABCD!!$$")).to be false
        end
      end
    end
  end
end
