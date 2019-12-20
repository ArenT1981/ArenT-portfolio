/* Filename:    fileio.c
 * Date:        13/02/02
 * Author: Aren Tyr.
 *
 * Description:
 *
 * Handles the basic file I/O for reading the maps in from *.map files 
 * in the ./maps directory.
 *
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

#include "fileio.h"
#include "parser.h"
#include "agent_actions.h"

void read_files_in()
{
	char *in_path = FILE_IN_PATH;
	char file_name[MAX_FILENAME_LENGTH];

	FILE *map_file;
	DIR *map_dir;

	struct dirent *dir_entry;
	
	int valid_file_name = FAIL;

	if((map_dir = opendir(in_path)) == NULL)
	{
		fprintf(stderr, "Can't open directory %s\n", in_path);
	}
	else
	{	/* Read the map files in */
		while((dir_entry = readdir(map_dir)) != NULL)
		{
			file_name[0] = '\0';

			/* Make sure to ignore the "." and ".." special files */
			if((strcmp(dir_entry->d_name, ".") != 0) && (strcmp(dir_entry->d_name, "..") != 0))
			{
			agent_print_update_string_arg("Parsing file: ", dir_entry->d_name);

			/* Build the filename */
			strcat(file_name, in_path);
			strcat(file_name, dir_entry->d_name);

			valid_file_name = check_file_name(file_name);

			if(valid_file_name == SUCCESS && (map_file = fopen(file_name, "r")) != NULL)
			{
				if(parse_file(map_file) == SUCCESS)
				{
					fclose(map_file);

					if((map_file = fopen(file_name, "r")) != NULL)
					{
						create_map(map_file);
						fclose(map_file);
					}
				}


			}
			else
			{
				agent_print_update_string_arg("Invalid map file: ", file_name);
			}

			}
		}
	}


}

int check_file_name(char *file_name)
{
	if(file_name != NULL)
	{
		while(*(file_name++) != '\0')
		{
			if(*file_name == '.')
			{
				file_name++;

				if(strcmp(file_name, "map") == 0)
					return SUCCESS;
 			}
		}

	}
	return FAIL;
}
