// bst-node-count.cpp
// Author: Aren Tyr (aren.unix@yandex.com)
//
// Date: 2019-12-01
// Version 1.0
//
// =============================================================================
// This program implements a recursive function to count the number of
// nodes in a given binary search tree. It potentially generates two
// recursive branches on each iteration/recursion if both left and right
// pointers do indeed point to child nodes.
// =============================================================================

#include <iostream>

class Node
{
public:
  Node *left, *right;
  Node() { left = right = nullptr; }
  ~Node()
  {
    delete left;
    left = nullptr;
    delete right;
    right = nullptr;
  }
};

int counter = 0;
bool init = true;

// Recursive function to return the count of nodes in BST
int count(Node *n)
{

  // Ensure counter is reset on each first run/subsequent call
  if(init == true)
    { counter = 0; }

  // base case
  if(n->left == nullptr && n->right == nullptr)
    {  ++counter; init = true; return counter; }
  else
    {
      init = false;
      ++counter;

      if(n->left != nullptr && n->right != nullptr)
        {  return (count(n->left) + count(n->right)); }
      else if(n->left != nullptr)
        { return count(n->left); } //++counter;}
      else if(n->right != nullptr)
        {  return count(n->right); } //+counter;}
    }
}

// Test function with some simple trees
int main()
{
  // Some test data

  // Tree with just one node (root)
  Node *p = new Node();

  // BST with six nodes
  Node *n = new Node();
  n->left = new Node();
  n->right = new Node();
  n->right->left = new Node();
  n->right->right = new Node();
  n->right->right->right = new Node();

  // BST with eleven nodes
  Node *r = new Node();
  r->left = new Node();
  r->right = new Node();
  r->right->left = new Node();
  r->right->right = new Node();
  r->right->right->right = new Node();
  r->left->right = new Node();
  r->left->left = new Node();
  r->left->left->right = new Node();
  r->left->left->left = new Node();
  r->left->left->left->left = new Node();

  // Should print one...
  std::cout << "Binary tree p has " << count(p) << " nodes." << std::endl;

  // Should print six...
  std::cout << "Binary tree n has " << count(n) << " nodes." << std::endl;

  // Should print eleven
  std::cout << "Binary tree r has " << count(r) << " nodes." << std::endl;

  // Clean up 
  delete p;
  p = nullptr;
  delete n;
  n = nullptr;
  delete r;
  r = nullptr;

  return 0;
}
