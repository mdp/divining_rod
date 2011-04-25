require 'test_helper'

module DiviningRod
  class MashTest < Test::Unit::TestCase
    context 'Mash is like Hash' do
      should "work that way" do
        mash = Mash.new({:a_key => "and a value"})
        and_mash = Mash.new({:my_key => "and my value"})
        assert_equal ({:a_key => "and a value", :my_key => "and my value"}), mash.merge(and_mash)
      end

      should "also mash tags" do
        mash = Mash.new({:tags => :foo})
        and_mash = Mash.new({:tags => [:bar, :baz]})
        assert_equal mash.merge(and_mash), {:tags => [:foo, :bar, :baz]}
      end

      should "accept nil happily" do
        mash = Mash.new(nil)
        assert_equal({}, mash)
      end
    end
  end
end

