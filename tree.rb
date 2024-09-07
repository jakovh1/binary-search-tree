# frozen_string_literal: true

# Class representing a Balanced Binary Search Tree.
#
# This class provides methods to:
#  - insert a value into the tree (public)
#  - delete a value from the tree (public)
#  - find if a provided value is present in the tree (public)
#  - collect values (it is also block-accepting method) of the tree in level-order order (public)
#  - collect values (it is also block-accepting method) of the tree in in-order order (public)
#  - collect values (it is also block-accepting method) of the tree in pre-order order (public)
#  - collect values (it is also block-accepting method) of the tree in post-order order (public)
#  - check a depth of a provided value (public)
#  - check whether the tree is balanced (public)
#  - rotate a subtree if it is unbalanced (invoked by insert() and delete() methods if needed) (private)
#  - build a tree (invoked when a "Tree" class is instantiated) (private)
#  - print the tree in the terminal (invoked by instantiation and every node insertion and deletion) (private)
class Tree

  def initialize(arr = [])
    @sorted_array = arr.uniq.sort
    @root = arr.empty? ? Node.new(nil) : build_tree(@sorted_array, 0, @sorted_array.length - 1)
    pretty_print unless @root.data.nil?
  end

  # Inserts a value into the tree 
  def insert(value, root = @root)
    if @root.data.nil? # Handles the case when the tree is empty
      return @root.data = value
    elsif root.nil? # Handles the case when the value is not in the tree and root of the tree is not 'nil'
      return Node.new(value)
    end

    if value < root.data
      root.left_node = insert(value, root.left_node)
    elsif value > root.data
      root.right_node = insert(value, root.right_node)
    else
      puts 'The provided value already exists in the tree.'
      return root
    end

    root.update_height
    root = rotate_if_necessary(root)

    if root == @root
      pretty_print
    else
      root
    end
  end

  # Deletes a value from the tree
  def delete(value, root = @root, is_outermost_call = true)

    if root.nil?
      puts 'The provided value does not exist in the tree.'
      return
    end

    if value < root.data
      root.left_node = delete(value, root.left_node, false)
    elsif value > root.data
      root.right_node = delete(value, root.right_node, false)
    elsif value == root.data
      unless root.left_node || root.right_node
        return nil unless root == @root # Handles the case when deleted value is not the root of the tree and the node does not have the children

        @root.data = nil    # Handles the case when deleted value is the root of the tree 
        return pretty_print # and the root of the tree does not have children
      end

      if root.left_node && !root.right_node
        return root.left_node unless root == @root # Handles the case when deleted value is not the root of the tree and has only left child

        @root = root.left_node # Handles the case when deleted value is the root of the tree and has only left child
        return pretty_print
      elsif !root.left_node && root.right_node
        return root.right_node unless root == @root # Handles the case when deleted value is not the root of the tree and has only right child

        @root = root.right_node # Handles the case when deleted value is the root of the tree and has only right child
        return pretty_print
      else
        inorder_successor = find_min_value(root.right_node) # Handles the case when deleted node has both children
        if value == @root.data
          @root.data = inorder_successor[0]
          @root.right_node = inorder_successor[1]
        else
          return Node.new(inorder_successor[0], root.left_node, inorder_successor[1])
        end
      end
    end

    root.update_height

    # root = rotate_if_necessary(root) unless (-1..1).include?(root.balance_factor)
    unless (-1..1).include?(root.balance_factor)
      if root.data == @root.data
        @root = rotate_if_necessary(root)
      else
        root = rotate_if_necessary(root)
      end
    end

    if is_outermost_call
      pretty_print
    else
      root
    end
  end

  # Finds a value in the tree.
  def find(value)
    tree = @root
    while tree
      if value < tree.data
        tree = tree.left_node
      elsif value > tree.data
        tree = tree.right_node
      else
        break
      end
    end

    tree.nil? ? 'The value is not found.' : "Node: #{tree.data}, Left child: #{tree.left_node&.data}, Right child: #{tree.right_node&.data}"
  end

  # Collects values (it is also block-accepting method) of the tree in level-order order
  def level_order(root = @root, queue = [@root], return_array = [], &block)
    if queue.empty?
      return return_array unless return_array.empty?
      nil
    end

    queue.shift

    queue.push(root.left_node) if root.left_node
    queue.push(root.right_node) if root.right_node

    if block_given?
      yield(root.data)
    else
      return_array.push(root.data)
    end

    level_order(queue[0], queue, return_array, &block)
  end

  # Collects values (it is also block-accepting method) of the tree in in-order order
  def inorder(root = @root, return_array = [], &block)

    
    inorder(root.left_node, return_array, &block) if root.left_node

    if block_given?
      yield(root)
    else
      return_array.push(root.data)
    end

    inorder(root.right_node, return_array, &block) if root.right_node

    return return_array unless return_array.empty?

  end

  # Collects values (it is also block-accepting method) of the tree in pre-order order
  def preorder(root = @root, return_array = [], &block)
    if block_given?
      yield(root)
    else
      return_array.push(root.data)
    end

    preorder(root.left_node, return_array, &block) if root.left_node
    preorder(root.right_node, return_array, &block) if root.right_node

    if root == @root
      return return_array unless return_array.empty?
      nil
    end
  end

  # Collects values (it is also block-accepting method) of the tree in post-order order
  def postorder(root = @root, return_array = [], &block)
    postorder(root.left_node, return_array, &block) if root.left_node
    postorder(root.right_node, return_array, &block) if root.right_node

    if block_given?
      yield(root)
    else
      return_array.push(root.data)
    end

    if root == @root
      return return_array unless return_array.empty?
      nil
    end
  end

  # Returns a depth of the provided node
  def depth(node)
    current = @root
    depth = 0
    until node == current.data || current.nil?
      current = node < current.data ? current.left_node : current.right_node
      depth += 1
    end
    current ? depth : 'Provided value does not exist in the tree.'
  end

  # Checks if the tree is balanced
  def balanced?
    return_value = true
    postorder do |node|
      unless (-1..1).include?((node.left_node ? node.left_node.height : -1) - (node.right_node ? node.right_node.height : -1))
        return_value = false
        break
      end
    end
    return_value
  end

  private

  def find_min_value(subtree, parent = nil)
    unless subtree.left_node
      return [subtree.data, subtree.right_node] if parent.nil?

      return_value = subtree.data.dup
      parent.left_node = subtree.right_node
      return [return_value, parent]
    end

    min_value = find_min_value(subtree.left_node, subtree)

    subtree.update_height

    min_value
  end

  # Performs right-right rotation
  def rr_rotation(root)
    new_root = root.right_node
    root.right_node = new_root.left_node
    new_root.left_node = root

    new_root.left_node.update_height
    new_root.update_height
    new_root
  end

  # Performs right-left rotation
  def rl_rotation(root)
    new_root = root.right_node.left_node

    root.right_node.left_node = new_root.right_node
    new_root.right_node = root.right_node

    root.right_node = new_root.left_node
    new_root.left_node = root

    new_root.right_node.update_height
    new_root.left_node.update_height
    new_root.update_height
    new_root
  end

  # Performs left-left rotation
  def ll_rotation(root)
    new_root = root.left_node
    root.left_node = new_root.right_node
    new_root.right_node = root

    new_root.right_node.update_height
    new_root.update_height
    new_root
  end

  # Performs left-right rotation
  def lr_rotation(root)
    new_root = root.left_node.right_node
    root.left_node.right_node = new_root.left_node
    new_root.left_node = root.left_node
    root.left_node = new_root.right_node
    new_root.right_node = root

    new_root.left_node.update_height
    new_root.right_node.update_height
    new_root.update_height

    new_root
  end

  # Performs a rotation if the subtree is unbalanced
  def rotate_if_necessary(root)
    if root.balance_factor == 2
      if root.left_node.balance_factor >= 0
        root = ll_rotation(root)

      elsif root.left_node.balance_factor.negative?
        root = lr_rotation(root)
      end
    elsif root.balance_factor == -2

      if root.right_node.balance_factor <= 0
        root = rr_rotation(root)

      elsif root.right_node.balance_factor.positive?
        root = rl_rotation(root)

      end
    end
    root
  end

  # Builds a tree out of an array
  def build_tree(arr, start_index, end_index)
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2

    Node.new(arr[mid_index], build_tree(arr, start_index, mid_index - 1), build_tree(arr, mid_index + 1, end_index))
  end

  # Prints the Binary Search Tree in the terminal
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}(#{node.height})"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end
end
