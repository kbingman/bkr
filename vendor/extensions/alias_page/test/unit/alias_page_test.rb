require File.dirname(__FILE__) + '/../test_helper'

class AliasPageTest < Test::Unit::TestCase
  extension_fixtures :pages

  def set_path( path )
    page = pages(:alias)
    page.parts.clear
    page.parts.create( :name => 'source', :content => path )
    page
  end

  def check_normal( path )
    set_path path

    page = find_alias
    assert page
    assert_equal pages(:normal), page

    page = Page.find_by_url '/subdir/alias/child'
    assert page
    assert_equal pages(:override), page

    page = Page.find_by_url '/subdir/alias/child2'
    assert page
    assert_equal pages(:child2), page
  end

  def find_alias
    Page.find_by_url '/subdir/alias'
  end

  def test_sibling
    set_path 'sibling'
    page = find_alias
    assert page
    assert_equal pages(:sibling), page
  end

  def test_normal_rel
    check_normal '../normal'
  end

  def test_normal_abs
    check_normal '/normal'
  end

  def test_not_found
    set_path 'garbage'
    page = find_alias
    assert page
    assert_equal pages(:not_found), page
  end

  def test_pages
    assert_equal pages(:root), Page.find_by_url('/')
    assert_equal pages(:normal), Page.find_by_url('/normal')
    assert_equal pages(:child), Page.find_by_url('/normal/child')
    assert_equal pages(:child2), Page.find_by_url('/normal/child2')
    assert_equal pages(:subdir), Page.find_by_url('/subdir')
    assert_equal pages(:sibling), Page.find_by_url('/subdir/sibling')
    assert_equal pages(:not_found), Page.find_by_url('garbage')
    assert_kind_of AliasPage, pages(:alias)
  end
end
