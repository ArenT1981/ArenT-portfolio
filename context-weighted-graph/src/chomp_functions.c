/* Filename:    chomp_fuctions.c
 * Date:        19/02/19
 * Author: Aren Tyr.
 *
 * Description:
 *
 * This program implements a agent-based contextual knowledge engine.
 *
 *
 */
#include <stdio.h>
#include "parser.h"
#include "chomp_functions.h"


//FIXME: rewrite all these functions to entirely use pointers (more efficient)

void chomp_whitespace(char array[], int *index)
{
	while(array[*index] == ' ' && array[*index] != ';' && array[*index] != '\0')
	{
		*index = *index + 1;
	}
}

void chomp_to_whitespace(char array[], int *index)
{
	while(array[*index] != ' ' && array[*index] != ';' /*&& array[*index] != '\n' */ && array[*index] != '\0')
	{
		*index = *index + 1;
	}
}

void chomp_to_endline(char array[], int *index)
{
	while(array[*index] != ';')
	{
		*index = *index + 1;
	}
}

int check_not_endline(char c)
{
	if(c != ';' && c != '\n' && c != '\0')
		return SUCCESS;
	else
		return FAIL;
}
