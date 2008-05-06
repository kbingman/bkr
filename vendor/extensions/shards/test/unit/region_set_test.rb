require File.dirname(__FILE__) + '/../test_helper'

class RegionSetTest < Test::Unit::TestCase
  def setup
    @region_set = Shards::RegionSet.new
  end

  def test_should_return_region_from_bracket_accessor
    @region_set.instance_variable_get("@regions")[:one] = ['a_partial']
    assert_equal ['a_partial'], @region_set[:one]
    assert_equal ['a_partial'], @region_set['one']
  end
  
  def test_should_return_blank_array_for_non_existent_region_from_bracket_accessor
    assert_equal [], @region_set[:non_existent]
    assert_equal [], @region_set['non_existent']
  end
  
  def test_should_return_existing_region_from_dot_accessor
    @region_set.instance_variable_get("@regions")[:one] = ['a_partial']
    assert_equal ['a_partial'], @region_set.one
  end
  
  def test_should_return_blank_array_for_non_existent_region_from_dot_accessor
    assert_equal [], @region_set.non_existent
  end
  
  def test_should_add_a_partial_to_the_end_of_a_region
    @region_set.add :main, "stuff"
    assert_equal ["stuff"], @region_set.main
    @region_set.add :main, "more_stuff"
    assert_equal ["stuff", "more_stuff"], @region_set.main
  end
  
  def test_should_add_a_partial_before_another
    @region_set.add :main, "stuff"
    assert_equal ["stuff"], @region_set.main
    @region_set.add :main, "more_stuff", :before => "stuff"
    assert_equal ['more_stuff', 'stuff'], @region_set.main
  end
  
  def test_should_add_a_partial_after_another
    @region_set.add :main, "stuff"
    @region_set.add :main, "more_stuff"
    assert_equal ["stuff", "more_stuff"], @region_set.main
    @region_set.add :main, "even_more", :after => "stuff"
    assert_equal ["stuff", "even_more", "more_stuff"], @region_set.main
  end
  
  def test_should_add_a_partial_at_end_if_before_is_not_found
    @region_set.add :main, "stuff"
    assert_equal ["stuff"], @region_set.main
    @region_set.add :main, "more_stuff", :before => "blah"    
    assert_equal ["stuff", "more_stuff"], @region_set.main
  end
  
  def test_should_add_a_partial_at_end_if_after_is_not_found
    @region_set.add :main, "stuff"
    assert_equal ["stuff"], @region_set.main
    @region_set.add :main, "more_stuff", :after => "blah"    
    assert_equal ["stuff", "more_stuff"], @region_set.main
  end

  def test_should_yield_self_to_new_block
    @region_set = Shards::RegionSet.new do |set|
      @inside_set = set
    end
    assert_equal @region_set, @inside_set
  end
end
