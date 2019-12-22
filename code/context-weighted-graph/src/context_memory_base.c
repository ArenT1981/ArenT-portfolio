/* Filename:    main.c
 * Date:        13/02/19
 * Author: Aren Tyr.
 *
 * Description:
 *
 * This file defines the main map generation/memory allocation algorithms
 * for producing the weighted graph/context map.
 *
 *
 */


#include <stdio.h>
#include <stdlib.h>

#include "context_memory_base.h"
#include "agent_actions.h"
#include "fileio.h"

int first_time = 1;

/* System set-up function, creates some necessary dummy structures */
void initialise_agent_map()
{
	/* possibly implement a "system" map, that maps all other maps? */
	dummy_connection.connection_id = 0;
	dummy_connection.connection_weight = 0;
	dummy_connection.connect_to = &dummy_node;
	dummy_connection.next_connection = &dummy_connection;
	dummy_connection.previous_connection = NULL;

	dummy_node.node_id = 0;
	dummy_node.node_title = "dummy node";
	dummy_node.next = NULL;
	dummy_node.previous = NULL;
	dummy_node.head_connection = &dummy_connection;

	dummy_map.topic = "dummy map";
	dummy_map.next = &dummy_map;
	dummy_map.previous = NULL;
	dummy_map.head_node = &dummy_node;

	agent_map_list.no_of_maps = 0;
	agent_map_list.head_map = &dummy_map;

}

/* Parse in the context files */
void parse_in_context_files()
{
	agent_print_action("Parsing in context files");
	read_files_in();

}

/* Set appropriate default setup values for new map & node */
void set_defaults(context_map *cm, node *nd, connection *ct)
{
	ct->connection_id = 0;
	ct->connection_weight = 0;

	/* WARNING: This line may cause infinite loops... */
	ct->connect_to = nd;
	ct->next_connection = NULL;
	ct->previous_connection = NULL;


	nd->node_title = "PLACEHOLDER";
	nd->node_id = 0;
	nd->previous = NULL;
	nd->next = NULL;
	nd->head_connection = ct;

	cm->head_node = nd;

	cm->next = NULL;
	cm->previous = agent_map_list.head_map;

	agent_map_list.head_map->next = cm;
	agent_map_list.head_map = cm;
}


/* Add a new node */
int add_node(int node_id, char *node_title, char *topic)
{
	int exit = 0;

	connection *default_connection = malloc(sizeof(connection) + 1);

	node *the_node = malloc(sizeof(node) + 1);
	the_node->node_title = node_title;
	the_node->node_id = node_id;

	the_node->head_connection = default_connection;

	/* Find the correct context map to add the node to, searching backwards */
	while(exit == 0)
	{
		if(strcmp(agent_map_list.head_map->topic, topic) == 0)
		{
			if(first_time == 1)
				dummy_node.next = the_node;

			the_node->next = NULL;
			the_node->previous = agent_map_list.head_map->head_node;

			agent_map_list.head_map->head_node->next = the_node;
			agent_map_list.head_map->head_node = the_node;
			
			exit = 1;

			agent_print_update_string_arg("Node successfully added: ", the_node->node_title);

			return SUCCESS;
		}
		if((exit == 0) && (agent_map_list.head_map->previous != NULL))
		{
			agent_map_list.head_map = agent_map_list.head_map->previous;
		}
		else
			return FAIL;

	}
		return FAIL;
}

/* Add a new map */
int add_map(char *topic)
{
	connection *temp_connection = malloc(sizeof(connection) + 1);
	node *temp_node = malloc(sizeof(node) + 1);
	context_map *new_map = malloc(sizeof(context_map) + 1);

	if(topic == NULL)
		return FAIL;

	set_defaults(new_map, temp_node, temp_connection);
	new_map->topic = topic;

	agent_print_action_string_arg("Map successfully added: ", new_map->topic);

	return SUCCESS;
}

int add_connection(char *connect_from, char *connect_to, int weight, char *cm_topic)
{
	int connect_from_matched = 0;
	int connect_to_matched = 0;
	int found = 0;
	int breakloop = 0;

	/* Pointers to appropriate node pointer */
	node *node_from_ptr;
	node *node_to_ptr;

	connection *the_connection = malloc(sizeof(connection) + 1);

	while(agent_map_list.head_map->previous != NULL && found == 0)
	{
		if(strcmp(agent_map_list.head_map->topic, cm_topic) == 0)
		{
			found = 1;

			while(breakloop == 0)
			{
				if(strcmp(agent_map_list.head_map->head_node->node_title, connect_from) == 0)
				{
					connect_from_matched = 1;
					node_from_ptr = agent_map_list.head_map->head_node;
				}
				else if(strcmp(agent_map_list.head_map->head_node->node_title, connect_to) == 0)
				{
					connect_to_matched = 1;
					node_to_ptr = agent_map_list.head_map->head_node;
				}

				if(agent_map_list.head_map->head_node->node_id > 1)
					agent_map_list.head_map->head_node = agent_map_list.head_map->head_node->previous;
				else
					breakloop = 1;
			}
		}
		
		/* Reset */
		while(agent_map_list.head_map->head_node->next != NULL)
			agent_map_list.head_map->head_node = agent_map_list.head_map->head_node->next;

		agent_map_list.head_map = agent_map_list.head_map->previous;
	}
	
	/* Reset */
	while(agent_map_list.head_map->next != NULL)
		agent_map_list.head_map = agent_map_list.head_map->next;

	if(connect_from_matched == 1 && connect_to_matched == 1)
	{
		the_connection->connect_to = node_to_ptr;
		the_connection->connection_weight = weight;
		the_connection->next_connection = NULL;
		the_connection->previous_connection = node_from_ptr->head_connection;
		
		node_from_ptr->head_connection->next_connection = the_connection;
		node_from_ptr->head_connection = the_connection;

		agent_print_update_string_arg("Connection successfully created from node: ", node_from_ptr->node_title);

		return SUCCESS;
	}

	return FAIL;
}

/* Display the maps in the system */
void display_context_maps()
{
	printf("\nContext maps stored: \n");
	printf("--------------------\n");

	while(agent_map_list.head_map->previous != NULL)
	{
		printf("Map: %s\n", agent_map_list.head_map->topic);
		agent_map_list.head_map = agent_map_list.head_map->previous;
	}

	//printf("Map: %s\n", agent_map_list.head_map->topic);

	/* Reset to other end of list ready for next display */
	while(agent_map_list.head_map->next != NULL)
		agent_map_list.head_map = agent_map_list.head_map->next;

	printf("=======================\n");

}

void display_nodes(char *cm_topic)
{
	int found = 0;

	while(agent_map_list.head_map->previous != NULL)
	{
		if(strcmp(agent_map_list.head_map->topic, cm_topic) == 0)
		{
			found = 1;

			printf("\nNodes in map \"%s\":\n", agent_map_list.head_map->topic);
			printf("--------------------\n");

			while(agent_map_list.head_map->head_node->previous != NULL)
			{
				printf("Node: %s, id = %d\n", agent_map_list.head_map->head_node->node_title, agent_map_list.head_map->head_node->node_id);

				printf("\tConnection list: \n");
				display_connections(agent_map_list.head_map->head_node);
				agent_map_list.head_map->head_node = agent_map_list.head_map->head_node->previous;
			}
			
			/* Reset to other end of list */
			while(agent_map_list.head_map->head_node->next != NULL)
				agent_map_list.head_map->head_node = agent_map_list.head_map->head_node->next;

		}

		agent_map_list.head_map = agent_map_list.head_map->previous;

	}

	/* Reset to other end of list */
	while(agent_map_list.head_map->next != NULL)
		agent_map_list.head_map = agent_map_list.head_map->next;

		
	if(found == 0)
		printf("No matching context map found.\n");
		
	printf("=======================\n");

}

void display_connections(node *the_node)
{
	int any_connections = 0;
	while(the_node->head_connection->previous_connection != NULL)
	{
		connection *dsp = the_node->head_connection;
		any_connections = 1;

		printf("\t-> %s, weight = %d\n", dsp->connect_to->node_title, dsp->connection_weight);
		the_node->head_connection = the_node->head_connection->previous_connection;
	}

	while(the_node->head_connection->next_connection != NULL)
		the_node->head_connection = the_node->head_connection->next_connection;

	if(any_connections == 0)
		printf("\t * 0 Connections\n");
}
