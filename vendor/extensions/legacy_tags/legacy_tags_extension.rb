class LegacyTagsExtension < Radiant::Extension
  version "1.0"
  description "This extension adds a new global tag <r:hello />."

  def activate
    Page.send :include, LegacyTags
  end
  
  def deactivate
  end
end