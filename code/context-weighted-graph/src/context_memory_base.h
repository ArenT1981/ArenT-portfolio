#ifndef __CONTEXT_MEMORY_BASE_
#define __CONTEXT_MEMORY_BASE_

#define MAX_MEMORY_MAPS 100
#define MAX_NODES 100

#define FAIL -1
#define SUCCESS 1



/* Forward declaration */
typedef struct node_list node;

typedef struct connection_list
{
	int connection_id;

	int connection_weight;

	node *connect_to;

	struct connection_list *next_connection;
	struct connection_list *previous_connection;

} connection;

/* List of nodes */
struct node_list
{
	int node_id;
	int node_depth_level;

	char *node_title;

	struct node_list *next;
	struct node_list *previous;
	
	connection *head_connection;

};

/* A context map */
typedef struct context_map
{
	int no_of_nodes;
	char *topic;
	node *head_node;

	struct context_map *next;
	struct context_map *previous;

} context_map;

/* A list of context maps */
typedef struct context_map_list
{
	int no_of_maps;

	context_map *head_map;

} context_map_list;

connection dummy_connection;
node dummy_node;
context_map dummy_map;
context_map_list agent_map_list;

int add_node(int node_id, char *node_title, char *topic);
int add_connection(char *connect_from, char *connect_to, int weight, char *cm_topic);
int add_map(char *topic);
void initialise_agent_map();
void parse_in_context_files();
void display_context_maps();
void set_defaults(context_map *cm, node *tn, connection *ct);
void display_nodes(char *cm_topic);
void display_connections(node *the_node);

#endif
