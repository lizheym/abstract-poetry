
require 'test_helper'

class RandomPoemHelperSpec < ActionDispatch::IntegrationTest
  RSpec.describe 'RandomPoemHelper' do
    describe ".random_poem" do
      let(:result) { RandomPoemHelper.random_poem }

      it "is a string" do
        expect(result.class).to eq(String)
      end

      it "has at most 10 lines" do
        expect(result.count("\n")).to be <= 10
      end

      it "has no lines longer than 100 characters" do
        expect(result.split("\n").map(&:length)).to all(be < 100)
      end
    end

    describe ".random_line" do
      let(:result) { RandomPoemHelper.random_line }

      it "is a string" do
        expect(result).to be_a(String)
      end
    end

    describe ".random_line_from_array" do
      let(:result) { RandomPoemHelper.random_line_from_array(array) }
      let(:array) { [
        "I have eaten",
        "the plums",
        "that were in",
        "the icebox",
        "and which",
        "you were probably",
        "saving",
        "for breakfast",
        "Forgive me",
        "they were delicious",
        "so sweet",
        "and so cold"]
      }

      it "is an element of the array" do
        expect(array).to include(result)
      end
    end

    describe ".random_poem_as_array" do
      let(:result) { RandomPoemHelper.random_poem_as_array }

      it "is an array of strings" do
        expect(result).to be_a(Array)
        expect(result).to all(be_a(String))
      end
    end
  end
end