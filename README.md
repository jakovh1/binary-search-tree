# binary-search-tree

## Description
A Ruby implementation of the Balanced Binary Search Tree data structure.

## Installation

1. Ensure Ruby is installed on your system
2. Clone the repository
  ```bash 
  https://github.com/jakovh1/binary-search-tree
  ```
3. Navigate to the project directory 
  ```bash
    cd binary-search-tree
  ```
4. Load necessary ruby files within irb
  ```bash
    irb -r ./node -r ./tree
  ```
5. Instantiate a Tree instance and store it to a variable. It is optional to pass an array as an argument.
   Without the argument, an user has to insert values manually with Tree#insert method.
  ```bash
    my_bst = Tree.new([100,1,34,78,50,9,97,86,54])
  ```

## Available Tree Instance Methods

1. **`#insert(value)`**  
   Inserts a new value into the tree. Takes one argument:
   - `value`: The value to insert into the tree.  
   If the value already exists, a duplicated is not inserted.

2. **`#delete(value)`**  
   Takes one argument, `value`, and deletes the value if the provided value is found in the tree. If the value is not found, returns a message.

3. **`#find(value)`**  
   Takes a `value` as an argument and returns the node if the value is found in the tree, or a failure message if it is not.

4. **`#level_order(&block)`**  
   Traverses the tree in breadth-first level order. If a block is provided, it yields each node to the block during the traversal. If no block is given, the method returns an array of node values in level-order order.

5. **`#inorder(&block)`**  
   Traverses the tree in in-order (left, root, right) order. If a block is provided, it yields each node to the block during the traversal. If no block is given, the method returns an array of node values in in-order order.

6. **`#preorder(&block)`**  
   Traverses the tree in pre-order (root, left, right) order. If a block is provided, it yields each node to the block during the traversal. If no block is given, the method returns an array of node values in pre-order order.

7. **`#postorder(&block)`**  
   Traverses the tree in post-order (left, right, root) order. If a block is provided, it yields each node to the block during the traversal. If no block is given, the method returns an array of node values in post-order order.

8. **`#depth(value)`**  
   Calculates and returns the depth of the specified value in the tree. Depth is defined as the number of edges in the path from the given node to the root node of the tree. If a non-existing value is provided, a failure message is returned.

9. **`#balanced?`**  
   Checks if the tree is balanced. A balanced tree is defined as one where, for every node, the difference in height between the left and right subtrees is no more than 1. Returns true if the tree is balanced and false otherwise.
