require File.dirname(__FILE__) + '/../test_helper'

class TemplateMock
  attr_accessor :block
  def capture(&block)
    @block = block
  end
end

class RegionPartialsTest < Test::Unit::TestCase
  def setup
    @template = TemplateMock.new
    @rp = Shards::RegionPartials.new(@template)
  end

  def test_should_have_hash_of_default_partials
    assert_not_nil @rp.instance_variable_get("@partials")
    assert_kind_of Hash, @rp.instance_variable_get("@partials")
  end
  
  def test_should_have_reference_to_template
    assert_not_nil @rp.instance_variable_get("@template")
    assert_kind_of TemplateMock, @rp.instance_variable_get("@template")
  end    
  
  def test_should_capture_block_when_passed
    @rp.edit_extended_metadata do
      puts "test"
    end
    
    assert_kind_of Proc, @template.block
    assert_equal @template.block, @rp.edit_extended_metadata
  end
  
  def test_should_respond_to_bracket_accessor
    assert_respond_to @rp, :[]
    @rp.instance_variable_get("@partials")["something"] = "foo"
    assert_equal @rp.instance_variable_get("@partials")["something"], @rp["something"]
  end
  
  def test_should_return_error_string_when_partial_does_not_exist
    assert_equal "<strong>`some_partial' default partial not found!</strong>", @rp["some_partial"]
  end
end
