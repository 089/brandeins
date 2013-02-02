# encoding: utf-8

class Class

  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

end
