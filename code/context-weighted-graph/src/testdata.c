#include <stdio.h>
#include <stdlib.h>
#include "context_memory_base.h"


void test_data()
{
/*	int temp;

	temp = add_map("Racing");
	temp = add_node(1, "F1", "Racing");
	temp = add_node(2, "F1000", "Racing");

	temp = add_connection("F1", "F1000", 4, "Racing"); */
	display_context_maps();

	display_nodes("fish");
    display_nodes("philosophers");
	//display_nodes("Racing");
}
