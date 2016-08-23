require 'xa/transforms/parse'

class ParseService
  class Parser
    include XA::Transforms::Parse
  end

  def self.parse_transformation(id)
    txm = Transformation.find(id)
    txm.update_attributes(content: Parser.new.parse(txm.src.split(/\r\n/))) if txm && txm.src
  end
end
