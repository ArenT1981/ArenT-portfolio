/* Filename:    main.c
 * Date:        13/02/19
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
#include "context_memory_base.h"
#include "testdata.h"
#include "agent_actions.h"

void start()
{
	initialise_agent_map();

	agent_print_action("*** Parsing context files in... ***");
	parse_in_context_files();
	agent_print_action("*** File input complete. ***");
	test_data();
}
