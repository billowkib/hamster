require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:reduce, :inject, :fold, :foldr].each do |method|
    describe "##{method}" do
      context "when empty" do
        it "returns the memo" do
          Hamster.hash.send(method, "ABC") {}.should == "ABC"
        end
      end

      context "when not empty" do
        let(:hash) { Hamster.hash("A" => "aye", "B" => "bee", "C" => "see") }

        context "with a block" do
          before do
            @result = hash.send(method, 0) { |memo, key, value| memo + 1 }
          end

          it "returns the final memo" do
            @result.should == 3
          end
        end

        context "with no block" do
          let(:hash) { Hamster.hash(a: 1, b: 2) }

          it "uses a passed string as the name of a method to use instead" do
            [[:a, 1, :b, 2], [:b, 2, :a, 1]].should include(hash.send(method, "+"))
          end

          it "uses a passed symbol as the name of a method to use instead" do
            [[:a, 1, :b, 2], [:b, 2, :a, 1]].should include(hash.send(method, :+))
          end
        end
      end
    end
  end
end