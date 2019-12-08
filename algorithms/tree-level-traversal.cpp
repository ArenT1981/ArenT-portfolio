// tree-level-traversal.cpp
// Author: Aren Tyr (aren.unix@yandex.com)
//
// Date: 2019-12-06
// Version 1.0
//
// =============================================================================
// Code snippet file showing implementation of level order traversal of
// a templated tree data structure (underlying ADT not implemented by me!).
//
// It iterates over a list until it is empty; as each node is reached,
// the presence of child nodes are checked, and if present, these
// children are added to the /back/ of the list. By continually adding
// elements to the back of the list, /popping/ the front one and noting
// the data (add to results vector), and iterating until the list is
// finally completely empty, the effect is to descend through the tree
// level-by-level until all the nodes have been traversed.
//
// It makes use of C++ powerful built in modern range-based iterator
// construct which leads to compact and efficient for loops. Entire tree
// data structure is passed into the function by reference, a tidy way
// of directly accessing the original data without explicitly passing pointers.
// =============================================================================

template <typename T>
std::vector<T> traverseLevels(GenericTree<T>& tree) {

	// Type alias for TreeNode dependent type.
	using TreeNode = typename GenericTree<T>::TreeNode;

	// Results vector to store traversal
	std::vector<T> results;

	// Get tree root node
	auto rootNodePtr = tree.getRootPtr();

	// If empty, immediately return
	if (!rootNodePtr)
		return results;

	// List to store currently remaining nodes to print
	std::list<const TreeNode*> nodesToPrint;

	// Push root node into front of print list to begin
	nodesToPrint.push_front(rootNodePtr);

	// Keep going until no nodes remain on list
	while (!nodesToPrint.empty())
	{
		// Add the first node data to our results list
		results.push_back(nodesToPrint.front()->data);

			// Do we have a node? If nullptr this will test false
			if (nodesToPrint.front())
			{
				// C++ iterator construct magic.
				// For each immediate child node, add it to back of our print list
				for (const auto &childPtr : nodesToPrint.front()->childrenPtrs)
				// If it is a node, not nullptr...
				if (childPtr)
				{
					//	Add it to the back of the print list
					nodesToPrint.push_back(childPtr);
				}
		}
		// Remove node at front of list, we've processed it
		nodesToPrint.pop_front();
	}

	return results;
}
