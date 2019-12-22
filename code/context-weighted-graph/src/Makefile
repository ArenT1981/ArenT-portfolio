CC = gcc
ARGS = -Wall

all: context_agent

clean:
	rm -f *.o

OBJECTS = context_graph.o context_memory_base.o parser.o main.o testdata.o agent_actions.o fileio.o chomp_functions.o

context_agent: $(OBJECTS)
	$(CC) $(ARGS) -o context_agent $(OBJECTS)

context_graph.o: context_graph.c context_memory_base.h parser.h testdata.h agent_actions.h
	$(CC) $(ARGS) -c context_graph.c

context_memory_base.o: context_memory_base.c context_memory_base.h agent_actions.h fileio.h
	$(CC) $(ARGS) -c context_memory_base.c

parser.o: parser.c parser.h agent_actions.h chomp_functions.h context_memory_base.h 
	$(CC) $(ARGS) -c parser.c

main.o: main.c context_graph.h
	$(CC) $(ARGS) -c main.c

testdata.o: testdata.c testdata.h context_memory_base.h
	$(CC) $(ARGS) -c testdata.c

agent_actions.o: agent_actions.c agent_actions.h
	$(CC) $(ARGS) -c agent_actions.c

fileio.o: fileio.c fileio.h agent_actions.h
	$(CC) $(ARGS) -c fileio.c

chomp_functions.o: chomp_functions.c chomp_functions.h parser.h
	$(CC) $(ARGS) -c chomp_functions.c

