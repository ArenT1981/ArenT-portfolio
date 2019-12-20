/* Filename:    parser.c
 * Date:        20/02/02
 * Author: Aren Tyr.
 *
 * Description:
 *
 * Parsing code for context map files. Responsible for checking validity of input files,
 * then creating the necessary map structures.
 *
 */

#include <stdio.h>
#include <ctype.h>  /* for iscntrl(c) */
#include <string.h>
#include <stdlib.h>

#include "parser.h"
#include "agent_actions.h"
#include "chomp_functions.h"
#include "context_memory_base.h"

/* Useful global variables */
int MAP_NAME = 0;
int NODE_COUNT = 0;
int CONNECTION_TOTAL = 0;

int node_id = 1;


/* Read in one single line from the file (max length 100 characters) */
void read_line(FILE *the_file, char *array, int *array_index)
{
	int c = 0;

	while((c = fgetc(the_file)) != STRING_END && (++(*array_index) < MAXLINE))
	{
		*array = (char)c;

		if(c == TERMINATION_SYMBOL)
			break;
		else
			array++;
	}
}

/* Perform the initial parse. At this stage we are simply interested in
   checking the file's syntactic validity. No structures are actually created yet. */
int parse_file(FILE *the_file)
{
	int c, i;

	/* Line buffer */
	char line[MAXLINE];

	/* (In)valid section flags */
	int header_line = 0;
	int node_lines = 0;
	int connection_lines = 0;

	/* Control flags */
	int header_section = 1;
	int node_section = 0;
	int connection_section = 0;

	/* Keep track of line number */
	int current_line = 0;

	i = -1;
	c = 0;
	do
	{
		read_line(the_file, &line[0], &i);

		current_line++;

		line[i+1] = '\0';

		i = 0;

		/* Enter the header section first */
		if(header_section == SUCCESS)
		{
			header_line = process_line(line, MAP);

			/* We should only have one header */
			if(header_line == SUCCESS)
			{
				header_section = 0;
				node_section = SUCCESS;

				/* Immediately read in the second line */
				read_line(the_file, &line[0], &i);
				current_line++;
			}
			else
			{
				header_line = FAIL;
			}
		}

		/* Enter the node creation section */
		if(node_section == SUCCESS)
		{
			node_lines = process_line(line, NODE);
			if(node_lines != SUCCESS)
			{
				/* Assume first that we have hit a connection line
				   and not a broken node line */
				node_lines = SUCCESS;
				node_section = 0;
				connection_section = SUCCESS;
			}
		}

		/* Enter the connection definition section */
		if(connection_section == SUCCESS)
		{
			connection_lines = process_line(line, CONNECTION);
			if(connection_lines != SUCCESS)
			{

				/* Is the "broken" line simply a result of hitting
				   the EOF? */
				int check_EOF = check_for_EOF(line);

				if(check_EOF == SUCCESS)
					connection_lines = SUCCESS;
				else
				{
					connection_lines = FAIL;
					node_lines = FAIL;
				}
			}

		}

		i = -1;

	} while((c = fgetc(the_file)) != EOF);


	//printf("header line = %d node_lines = %d connection_lines %d\n", header_line, node_lines, connection_lines);

	if(header_line == SUCCESS && node_lines == SUCCESS && connection_lines == SUCCESS)
		return SUCCESS;
	else
	{
		agent_print_update_num_arg("There is at least one error in the map file. See line: ", current_line);
		return FAIL;
	}


}

/* Check the syntax of the given line */
int process_line(char line[], int mode)
{
	int i = 0;
	
	/* Token matching flags */
	int plus_token = 0;
	int map_token = 0;
	int map_name = 0;

	int node_token = 0;
	int node_name = 0;

	int connection_token = 0;
	int connection_line = 0;

	int line_matched = 0;

	/* Check the line until the end (or worse) */
	while(line_matched == 0 && i < MAXLINE && line[i] != TERMINATION_SYMBOL && line[i] != STRING_END)
	{

		/* Eat up whitespace */
		if(line[i] == ' ' && (i < MAXLINE - 1))
			i++;
		else if(line[i] == ADD_SYMBOL) /* Match + */
		{
			plus_token = SUCCESS;
			i++;
		}
		else if(line[i] == CONNECTION_SYMBOL) /* Match @ */
		{
			connection_token = SUCCESS;
			i++;
		}
		else if(iscntrl(line[i]) > 0) /* Match any control characters e.g. '\n' */
		{
			i++;
		}
		else
			i++;

		/* Are we parsing a map header line? */
		if(mode == MAP)
		{
			if((i < MAXLINE - 5) && plus_token == SUCCESS && line[i] == 'm')
			{
				if(line[i+1] == 'a' && line[i+2] == 'p' && line[i+3] == ' ')
				{
					map_token = SUCCESS;

					i += 4;

					/* chomp any leading whitespace */
					chomp_whitespace(line, &i);

					if(isalnum(line[i]) > 0)
					{
						MAP_NAME = i;
						map_name = SUCCESS;
						line_matched = SUCCESS;
						break;

					}

				}
			}
		}
		else if(mode == NODE) /* Are we parsing a node creation line? */
		{
			if((i < MAXLINE - 6) && plus_token == SUCCESS && line[i] == 'n')
			{
				if(line[i+1] == 'o' && line[i+2] == 'd' && line[i+3] == 'e' && line[i+4] == ' ')
				{
					node_token = SUCCESS;

					i += 5;

					chomp_whitespace(line, &i);

					if(isalnum(line[i]) > 0)
					{
						NODE_COUNT++;
						node_name = SUCCESS;
						line_matched = SUCCESS;
						break;

					}

				}
			}
		}
		else if(mode == CONNECTION) /* Or a connection definition line? */
		{
			if(connection_token == SUCCESS)
			{

				chomp_whitespace(line, &i);

				if(isalnum(line[i]) > 0)
				{
					chomp_to_whitespace(line, &i);

					if(check_not_endline(line[i]) == SUCCESS)
					{
						chomp_whitespace(line, &i);

						if(isalnum(line[i]) > 0)
						{
							chomp_to_whitespace(line, &i);
							chomp_whitespace(line, &i);

							if(isdigit(line[i]) > 0)
							{
								CONNECTION_TOTAL++;
								connection_line = SUCCESS;
								line_matched = SUCCESS;
							}
						}

					}
				}
			}

		}
	}

	/* See if the line is valid */
	if(plus_token == SUCCESS && map_token == SUCCESS && map_name == SUCCESS && mode == MAP)
	{
		agent_print_update("Valid map line definition detected.");
		return SUCCESS;
	}
	else if(plus_token == SUCCESS && node_token == SUCCESS && node_name == SUCCESS && mode == NODE)
	{
		agent_print_update_num_arg("Valid node line definition detected. Node total: ", NODE_COUNT);
		return SUCCESS;
	}
	else if(connection_token == SUCCESS && connection_line == SUCCESS && mode == CONNECTION)
	{
		agent_print_update_num_arg("Valid node connection definition detected. Connection total: ", CONNECTION_TOTAL);
		return SUCCESS;
	}
	else
		return FAIL;

}

/* Check for the EOF. This is necessary to avoid errors parsing the last line
   in the file */
int check_for_EOF(char *line)
{
	while(*(line++) != EOF)
		if(isalnum(*line) > 0)
			return FAIL;

	return SUCCESS;

}

/* Actually create the context map. We have established that the file at this point is
   at least syntactically correct */
void create_map(FILE *the_file)
{

	int i;
	char line[MAXLINE];

	char *map_name;
	int node_lines_created = 0;
	int connection_lines_created = 0;

	i = -1;

	read_line(the_file, &line[0], &i);
	line[i+1] = '\0';


	/* Check the map name, indexing into the point in file that we established
	   earlier */
	map_name = create_map_name(line, MAP_NAME);

	i = -1;
	read_line(the_file, &line[0], &i);

	node_lines_created = create_nodes(the_file, line, 0, map_name);

	//i = -1;
	//read_line(the_file, &line[0], &i);

	connection_lines_created = create_connections(the_file, line, 0, map_name);


}

/* Create the context map structure */
char *create_map_name(char line[MAXLINE], int index)
{
	char *map_string_pointer;
	int i = 0;

	i = index;

	/* Keep a pointer indexing to the start of the map name */
	map_string_pointer = &line[index];

	/* Eat up the text */
	chomp_to_endline(line, &index);

	/* Terminate string */
	line[index] = '\0';

	/* Allocate memory for map name */
	map_string_pointer = malloc(sizeof(strlen(&line[i])));

	/* Copy the map name to free space */
	strcpy(map_string_pointer, &line[i]);

	/* Create a map of this name */
	i = add_map(map_string_pointer);


	return map_string_pointer;
}

int create_nodes(FILE *the_file, char line[MAXLINE], int index, char *map_name)
{
	int j = 0;
	int i = 0;
	int k = 0;

	char *node_string_pointer;


	for(j = 0; j < NODE_COUNT; j++)
	{
		/* Eat up to node string */
		chomp_to_whitespace(line, &i);
		chomp_whitespace(line, &i);
		chomp_to_whitespace(line, &i);
		chomp_whitespace(line, &i);

		/* Set pointer to start of string */
		node_string_pointer = &line[i];
		k = i;

		while(line[i] != ';')
			i++;
		line[i] = '\0';

		/* Allocate heap memory and copy string */
		node_string_pointer = malloc(sizeof(strlen(&line[k])));
		strcpy(node_string_pointer, &line[k]);

		/* Add the node */
		i = add_node(node_id, node_string_pointer, map_name);
		node_id++;

		/* Read the next line in */
		i = -1;
		read_line(the_file, &line[0], &i);

		i = 0;
	}

	return SUCCESS;
}

int create_connections(FILE *the_file, char line[MAXLINE], int index, char *map_name)
{
	int j = 0;
	int k = 0;
	int i = 0;
	int p = 0;
	int m = 0;

	char *node_string1_pointer;
	char *node_string2_pointer;
	
	char *weight_val_pointer;

	int weight_val;

	for(m = 0; m < CONNECTION_TOTAL; m++)
	{
		/* Eat up to node string */
		chomp_to_whitespace(line, &i);
		chomp_whitespace(line, &i);

		node_string1_pointer = &line[i];
		k = i;

		chomp_to_whitespace(line, &i);

		line[i] = '\0';
		i++;

		chomp_whitespace(line, &i);

		node_string2_pointer = &line[i];
		j = i;

		chomp_to_whitespace(line, &i);

		line[i] = '\0';
		i++;

		chomp_whitespace(line, &i);
		weight_val_pointer = &line[i];
		p = i;
		chomp_to_whitespace(line, &i);
		line[i] = '\0';


		weight_val = atoi(&line[p]) ;

		i = add_connection(node_string1_pointer, node_string2_pointer, weight_val, map_name);

		i = -1;
		read_line(the_file, &line[0], &i);

		i = 0;

	}

	return SUCCESS;
}