module UIControlWrap
  def when(events, options={}, &block)
    @callback ||= {}
    @callback[events] ||= []
    
    unless options[:append]
      @callback[events] = []
      removeTarget(nil, action: nil, forControlEvents: events)
    end

    @callback[events] << block
    addTarget(@callback[events].last, action:'call', forControlEvents: events)
  end
end
[[UIControl, UIControlWrap]].each { |base, wrapper| base.send(:include, wrapper) }

module Kernel
  def NSLocalizedString(default=nil, key)
    default ||= key
    NSBundle.mainBundle.localizedStringForKey(key, value:default, table:nil)
  end

  def NSAssert(condition, message ="Assertion on failed")
    abort("#{caller}: #{message}") unless condition
  end
end