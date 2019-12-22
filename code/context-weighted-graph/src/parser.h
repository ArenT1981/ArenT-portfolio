#ifndef __PARSER_
#define __PARSER_

#define MAXLINE 100
#define SUCCESS 1
#define FAIL -1

#define MAP 0
#define NODE 1
#define CONNECTION 2

#define ADD_SYMBOL '+'
#define CONNECTION_SYMBOL '@'
#define TERMINATION_SYMBOL ';'
#define STRING_END '\0'

void read_line(FILE *the_file, char *array, int *array_index);
int parse_file();
int process_line(char line[], int mode);
void create_map(FILE *the_file);
char *create_map_name(char line[MAXLINE], int index);
int create_nodes(FILE *the_file, char line[MAXLINE], int index, char *map_name);
int create_connections(FILE *the_file, char line[MAXLINE], int index, char *map_name);
int check_for_EOF(char *line);

#endif
