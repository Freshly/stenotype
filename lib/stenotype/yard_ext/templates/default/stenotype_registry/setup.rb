# frozen_string_literal: true

def init
  sections :header,
           :stenotype_methods_list, [T('method_registry')]
end

def methods_list
  Stenotype::YardExt::Handlers::MethodsEnum.tracked_methods.each do |name|
    items = find_method_by_name(name)
    next unless items # Some of the methods might unused
    yield(items, name) unless items.children.empty?
  end
end

def find_method_by_name(name)
  object.children.detect { |c| c.name == name }
end
