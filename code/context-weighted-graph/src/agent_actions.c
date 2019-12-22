/* Filename:    agent_actions.c
 * Date:        17/02/19
 * Author: Aren Tyr.
 *
 * Description:
 *
 * Actions the agent performs.
 *
 */

#include <stdio.h>

void agent_print_action(char *action_message)
{
	if(action_message != NULL)
		printf("* ACTION: %s\n", action_message);
}

void agent_print_action_string_arg(char *action_message, char *argument)
{
	if(action_message != NULL)
		printf("* ACTION: %s%s\n", action_message, argument);

}
void agent_print_update(char *update_message)
{
	if(update_message != NULL)
		printf("  -> UPDATE: %s\n", update_message);
}

void agent_print_update_string_arg(char *update_message, char *argument)
{
	if(update_message != NULL)
		printf("  -> UPDATE: %s%s\n", update_message, argument);

}

void agent_print_update_num_arg(char *update_message, int num_arg)
{
	if(update_message != NULL)
		printf("  -> UPDATE: %s%d\n", update_message, num_arg);
}
