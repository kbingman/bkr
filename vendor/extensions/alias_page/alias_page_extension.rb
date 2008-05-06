class AliasPageExtension < Radiant::Extension
  version "0.2"
  description "An extension to make a page give another page's content"
  url "http://silverinsanity.com/~benji/radiant/"

  def activate
    AliasPage
  end
  
  def deactivate
  end
    
end
