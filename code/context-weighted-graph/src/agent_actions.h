#ifndef __AGENT_ACTIONS_
#define __AGENT_ACTIONS_

void agent_print_action(char *action_message);
void agent_print_action_string_arg(char *action_message, char *argument);
void agent_print_update(char *update_message);
void agent_print_update_string_arg(char *update_message, char *argument);
void agent_print_update_num_arg(char *update_message, int num_arg);

#endif
