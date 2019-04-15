require 'test_helper'

class PoemsHelperTest < ActionDispatch::IntegrationTest
  RSpec.describe 'PoemsHelper' do
    describe ".cycle_nouns_in_text" do
      let(:result) { PoemsHelper.cycle_nouns_in_text(text) }

      context "with no nouns" do
        let(:text) { "Pretty, purple, and small" }

        it "is the original text" do
          expect(result).to eq("Pretty, purple, and small")
        end
      end

      context "with nouns" do
        context "with a dash" do
          let(:text) { "I like the crazy-lady with the hair" }

          it "cycles the nouns" do
            expect(result).to eq("I like the crazy-hair with the lady")
          end
        end

        context "with punctuation" do
          let(:text) { "I wish I were a witch... But I'm a mermaid" }

          it "cycles the nouns" do
            expect(result).to eq("I wish I were a mermaid... But I'm a witch")
          end
        end

        context "with a repeated noun" do
          let(:text) { "The dog and the cat are friends. I like my dog." }

          it "cycles the nouns" do
            expect(result).to eq("The dog and the dog are cat. I like my friends.")
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
          expect(result).to eq("I was a lonely teenage broncin buck\r\n")
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
      let(:result) { PoemsHelper.fix_articles(text) }

      context "with no articles" do
        let(:text) { "I love apples" }

        it "is empty" do
          expect(result).to eq("I love apples")
        end
      end

      context "with the correct articles" do
        let(:text) { "An apple a day" }

        it "is the articles" do
          expect(result).to eq("An apple a day")
        end
      end

      context "with partially correct articles" do
        let(:text) { "A apple a day" }

        it "is the correct articles" do
          expect(result).to eq("An apple a day")
        end
      end

      context "with incorrect articles" do
        let(:text) { "A apple an day" }

        it "is the correct articles" do
          expect(result).to eq("An apple a day")
        end
      end
    end

    describe ".replace_placeholders_with_words" do
      let(:result) { PoemsHelper.replace_placeholders_with_words(text, words) }

      context "with no words" do
        let(:text) { "Pretty pretty pretty" }
        let(:words) { [] }

        it "returns the original text" do
          expect(result).to eq("Pretty pretty pretty")
        end
      end

      context "with a word" do
        let(:text) { "A good #{PoemsHelper::PLACEHOLDER}" }
        let(:words) { ["doggie"] }

        it "returns the text with the word replaced" do
          expect(result).to eq("A good doggie")
        end
      end

      context "with a multiple words" do
        let(:text) { "A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}" }
        let(:words) { ["doggie", "kittie"] }

        it "returns the text with words replaced" do
          expect(result).to eq("A good doggie and kittie")
        end
      end

      context "with a repeated word" do
        let(:text) { "A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}" }
        let(:words) { ["doggie", "doggie"] }

        it "returns the text with words replaced" do
          expect(result).to eq("A good doggie and doggie")
        end
      end
    end

    describe ".replace_words_with_placeholders" do
      let(:result) { PoemsHelper.replace_words_with_placeholders(text, words) }

      context "with no nouns" do
        let(:text) { "Pretty pretty pretty" }
        let(:words) { [] }

        it "returns the original text" do
          expect(result).to eq("Pretty pretty pretty")
        end
      end

      context "with a noun" do
        let(:text) { "A good doggie" }
        let(:words) { ["doggie"] }

        it "returns the text with the noun replaced" do
          expect(result).to eq("A good #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a multiple nouns" do
        let(:text) { "A good doggie and kittie" }
        let(:words) { ["doggie", "kittie"] }

        it "returns the text with nouns replaced" do
          expect(result).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a repeated noun" do
        let(:text) { "A good doggie and doggie" }
        let(:words) { ["doggie", "doggie"] }

        it "returns the text with nouns replaced" do
          expect(result).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end
    end

    describe ".get_words_in_order_by_part_of_speech" do
      let(:result) { PoemsHelper.get_words_in_order_by_part_of_speech(text, PoemsHelper::NOUN_LIST) }

      context "nouns" do
        context "with a simple sentence" do
          let(:text) { "I gave my dog a gift for the holiday." }

          it "returns the nouns in order" do
            expect(result).to eq(["dog", "gift", "holiday"])
          end
        end

        context "with proper nouns" do
          let(:text) { "I gave Katie a gift for the holiday." }

          it "returns the nouns in order" do
            expect(result).to eq(["Katie", "gift", "holiday"])
          end
        end

        context "with multiple sentences" do
          let(:text) { "I gave Katie a gift for the holiday. She liked the shirt I gave her, but she wished it were a computer." }

          it "returns the nouns in order" do
            expect(result).to eq(["Katie", "gift", "holiday", "shirt", "computer"])
          end
        end

        context "with a repeated noun" do
          let(:text) { "I love my cat. What a good cat." }

          it "returns the nouns in order" do
            expect(result).to eq(["cat", "cat"])
          end
        end

        context "with an em dash" do
          let(:text) { "Birds fly quickly—birds with wings." }

          it "returns the nouns in order" do
            expect(result).to eq(["Birds", "birds", "wings"])
          end
        end

        context "with a dash" do
          let(:text) { "Like quick-silver." }

          it "returns the nouns in order" do
            expect(result).to eq(["silver"])
          end
        end

        context "with a semicolon" do
          let(:text) { "I like my birds; they have wings." }

          it "returns the nouns in order" do
            expect(result).to eq(["birds", "wings"])
          end
        end

        context "with a quotation mark" do
          let(:text) { "Birds say \"dog.\"" }

          it "doesn't include the noun enclosed in quotes" do
            expect(result).to eq(["Birds"])
          end
        end
      end
    end

    describe ".get_articles_in_order" do
      let(:result) { PoemsHelper.get_articles_in_order(text) }

      context "with no articles" do
        let(:text) { "I love apples" }

        it "is empty" do
          expect(result).to eq([])
        end
      end

      context "with articles" do
        let(:text) { "An apple a day" }

        it "is the articles in order" do
          expect(result).to eq(["An", "a"])
        end
      end
    end

    describe ".get_correct_articles" do
      let(:result) { PoemsHelper.get_correct_articles(text) }

      context "with no articles" do
        let(:text) { "I love apples" }

        it "is empty" do
          expect(result).to eq([])
        end
      end

      context "with the correct articles" do
        let(:text) { "An apple a day" }

        it "is the articles" do
          expect(result).to eq(["An", "a"])
        end
      end

      context "with partially correct articles" do
        let(:text) { "A apple a day" }

        it "is the correct articles" do
          expect(result).to eq(["An", "a"])
        end
      end

      context "with incorrect articles" do
        let(:text) { "A apple an day" }

        it "is the correct articles" do
          expect(result).to eq(["An", "a"])
        end
      end
    end

    describe ".is_alpha?" do
      let(:result) { PoemsHelper.is_alpha?(text) }

      context "with all lowercase letters" do
        let(:text) { "abcd" }

        it "is true" do
          expect(result).to be true
        end
      end

      context " with uppercase and lowercase letters" do
        let(:text) { "abcdABCD" }

        it "is true" do
          expect(result).to be true
        end
      end

      context "with spaces" do
        let(:text) { "abcd ABCD" }

        it "is false" do
          expect(result).to be false
        end
      end

      context "with special characters" do
        let(:text) { "abcdABCD!!$$" }

        it "is false" do
          expect(result).to be false
        end
      end
    end
  end
end
