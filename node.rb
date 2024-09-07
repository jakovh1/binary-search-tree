# frozen_string_literal: true

# Class representing a Node.
#
# This class provides methods to:
#  - calculate balance factor of the node
#  - update height of the node
class Node
  attr_accessor :data, :left_node, :right_node, :height

  def initialize(data, left_node = nil, right_node = nil)
    @data = data
    @left_node = left_node
    @right_node = right_node
    @height = 1 + [@left_node ? @left_node.height : -1, @right_node ? @right_node.height : -1].max
  end

  def balance_factor
    (@left_node ? @left_node.height : -1) - (@right_node ? @right_node.height : -1)
  end

  def update_height
    @height = 1 + [@left_node ? @left_node.height : -1, @right_node ? @right_node.height : -1].max
  end
end
