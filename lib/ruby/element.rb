require 'docile'

require_relative 'element/base'
require_relative 'element/button'
require_relative 'element/canvas'
require_relative 'element/division'
require_relative 'element/form'
require_relative 'element/iframe'
require_relative 'element/image'
require_relative 'element/input'
require_relative 'element/header'
require_relative 'element/list'
require_relative 'element/label'
require_relative 'element/paragraph'
require_relative 'element/select'
require_relative 'element/table'
require_relative 'element/textarea'

Crimson::Element.constants.select { |c| Crimson::Element.const_get(c).is_a? Class }.each do |element|
  Crimson::Element::Base.send(:define_method, element) do |*args, &block|
    child = Crimson::Element.const_get(element).new(*args, parent: self)
    Docile.dsl_eval(child, &block) if block
    child
  end
end