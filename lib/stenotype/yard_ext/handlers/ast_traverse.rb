# frozen_string_literal: true

require 'parser/current'

class AstTraverse < Parser::AST::Processor
  attr_reader :filepath, :parser, :ast
  def initialize(parser)
    @filepath = parser.file
    @parser = parser # This is needed further for registering the objects
    @ast = Parser::CurrentRuby.parse_file(filepath)
  end

  def run
    process(@ast)
  end

  def on_send(node)
    _receiver, method_name, _event_name, *_args = *node

    if method_names.include?(method_name)
      StenotypeMethodsHandler.new(parser, node).process
    end

    super
  end

  def method_names
    MethodsEnum.tracked_methods
  end
end

YARD::Parser::SourceParser.after_parse_file do |parser|
  puts parser.file
  AstTraverse.new(parser).run
end
