// insertion-and-merge-sort.cpp
// Author: Aren Tyr (aren.unix@yandex.com)
//
// Date: 2019-11-30
// Version 1.0
//
// =============================================================================
// Code snippet file showing implementation of an insertion sort and
// merge sort, order n^2 (worst case) and order n respectively.
//
// It implements it at a fairly low level, manually setting the corresponding
// pointers of the doubly linked list data structure. In the real world,
// you would instead make use of the STL functions provided by the C++
// STL on ADTs like the list, vector, etc.
//
// The merge sort function makes used of relevant push() and pop()
// operators to insert/remove elements accordingly and deals with each
// base case.
// =============================================================================

// Prevent the header from being included more than once per cpp file
#pragma once

#include <iostream>
#include <string>

// Included library not in this repository
#include "LinkedList.h"

// Insertion Sort
template <typename T>
void LinkedList<T>::insertOrdered(const T& newData) {

  // Allocate memory for new node 
  Node * newNode = new Node(newData);
  Node * cur = head_;
  Node * prev = head_;
  bool inserted = false;

  // Check for empty list
  if (size_ == 0)
    {
      head_ = newNode;
      tail_ = newNode;
      newNode->next = nullptr;
      newNode->prev = nullptr;
      ++size_;

      inserted = true;
    }

  // Traverse list
  while (inserted == false)
    {

        if(newNode->data <= cur->data)
        {
          // If inserted at front/head of list...
          if(cur == head_)
          {
             // Update head_ ptr
              head_ = newNode;
              cur->prev = newNode;
              newNode->next = cur;
              newNode->prev = nullptr;
          }
          else
            {
              // Inserting somewhere in middle of list
              newNode->next = cur;
              newNode->prev = cur->prev;
              cur->prev = newNode;
              prev->next = newNode;

            }

          ++size_;
          inserted = true;

          continue;
        }

      // Have we reached end/tail of list?
      if(cur == tail_)
        {
          cur->next = newNode;
          newNode->next = nullptr;
          newNode->prev = cur;
          tail_ = newNode;
          inserted = true;
          ++size_;
          continue;
        }

      // Step forward
      prev = cur;
      cur = cur->next;
    }
}

// Merge Sort
template <typename T>
LinkedList<T> LinkedList<T>::merge(const LinkedList<T>& other) const {

  LinkedList<T> left = *this;
  LinkedList<T> right = other;

  LinkedList<T> merged;

  bool done = false;

  while (done != true)
    {

      // Base case 1: Left list is empty...
      while(left.empty() == true && right.empty() == false)
        { merged.pushBack(right.front()); right.popFront(); }

      // Base case 2: Right list is empty...
      while(right.empty() == true && left.empty() == false)
        { merged.pushBack(left.front()); left.popFront(); }

      // Are we done yet - are both lists empty?
      if (left.empty() == true && right.empty() == true)
        { done = true; continue; }

      // If one list is now completely empty, send it round 
      if(left.empty() == true || right.empty() == true)
        { continue;  }

      // Neither is empty, so do merge accordingly 
      if(left.front() == right.front())
        {
          merged.pushBack(left.front());
          merged.pushBack(right.front());
          left.popFront();
          right.popFront();
          //continue;
        }
      else if(left.front() < right.front())
        {
          merged.pushBack(left.front());
          left.popFront();
          //continue;
        }

      else if(right.front() < left.front())
        {
          merged.pushBack(right.front());
          right.popFront();
          //continue;
        }

    }
  
  return merged;
}
