class BasePresenter
  def initialize object, template
    @object = object
    @template = template
  end

  private
  class << self
    def presenters name
      define_method(name) {@object}
    end
  end

  def method_missing *args, &block
    @template.send *args, &block
  end
end
