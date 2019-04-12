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

    describe ".cycle_noun_array" do
      it "moves each element forward one position" do
        expect(PoemsHelper.cycle_noun_array(["a", "b", "c"])).to eq(["c", "a", "b"])
      end
    end

    describe ".replace_placeholders_with_nouns" do
      context "with no nouns" do
        it "returns the original text" do
          expect(PoemsHelper.replace_placeholders_with_nouns("Pretty pretty pretty", [])).to eq("Pretty pretty pretty")
        end
      end

      context "with a noun" do
        it "returns the text with the noun replaced" do
          expect(PoemsHelper.replace_placeholders_with_nouns("A good #{PoemsHelper::PLACEHOLDER}", ["doggie"])).to eq("A good doggie")
        end
      end

      context "with a multiple nouns" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_placeholders_with_nouns("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}", ["doggie", "kittie"])).to eq("A good doggie and kittie")
        end
      end

      context "with a repeated noun" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_placeholders_with_nouns("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}", ["doggie", "doggie"])).to eq("A good doggie and doggie")
        end
      end
    end

    describe ".replace_nouns_with_placeholders" do
      context "with no nouns" do
        it "returns the original text" do
          expect(PoemsHelper.replace_nouns_with_placeholders("Pretty pretty pretty", [])).to eq("Pretty pretty pretty")
        end
      end

      context "with a noun" do
        it "returns the text with the noun replaced" do
          expect(PoemsHelper.replace_nouns_with_placeholders("A good doggie", ["doggie"])).to eq("A good #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a multiple nouns" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_nouns_with_placeholders("A good doggie and kittie", ["doggie", "kittie"])).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end

      context "with a repeated noun" do
        it "returns the text with nouns replaced" do
          expect(PoemsHelper.replace_nouns_with_placeholders("A good doggie and doggie", ["doggie", "doggie"])).to eq("A good #{PoemsHelper::PLACEHOLDER} and #{PoemsHelper::PLACEHOLDER}")
        end
      end
    end

    describe ".get_nouns_in_order" do
      context "with a simple sentence" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("I gave my dog a gift for the holiday.")).to eq(["dog", "gift", "holiday"])
        end
      end

      context "with proper nouns" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("I gave Katie a gift for the holiday.")).to eq(["Katie", "gift", "holiday"])
        end
      end

      context "with multiple sentences" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("I gave Katie a gift for the holiday. She liked the shirt I gave her, but she wished it were a computer.")).to eq(["Katie", "gift", "holiday", "shirt", "computer"])
        end
      end

      context "with a repeated noun" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("I love my cat. What a good cat.")).to eq(["cat", "cat"])
        end
      end

      context "with an em dash" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("Birds fly quickly—birds with wings.")).to eq(["Birds", "birds", "wings"])
        end
      end

      context "with a dash" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("Like quick-silver.")).to eq(["silver"])
        end
      end

      context "with a semicolon" do
        it "returns the nouns in order" do
          expect(PoemsHelper.get_nouns_in_order("I like my birds; they have wings.")).to eq(["birds", "wings"])
        end
      end
    end
  end
end
