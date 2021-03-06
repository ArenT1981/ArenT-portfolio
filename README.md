# Aren's Development Portfolio

[<img src="./assets/img/portfolio-banner1.png">](https://www.linkedin.com/in/aren-tyr/) 

[<img src="./assets/img/development-log-banner.png">](./assets/daily-log.org) 

## [Development Log](./assets/daily-log.org)

See my [daily log](./assets/daily-log.org) for a detailed time-tracked summary of my learning. This also reflects my **attention to detail**, **organisation/project management skills**, and above all, **work ethic/consistency**.  

[<img src="./assets/img/academic-writing-banner.png">](./writing/Academic-and-Technical-Writing-examples) 

## [Academic & Technical Writing](./writing/Academic-and-Technical-Writing-examples)

This contains a representative sample of the quality of my general writing and documentation ability. A detailed summary is presented in the README inside the directory. Though not IT specific, I feel it is very important to include it in this portfolio because software engineering is about *far* more than just writing code; the production of clear, high quality, and professional documents is crucial.  

[<img src="./assets/img/my-setup-banner.png">](./assets/config)

## [**My Configuration/Linux Setup**](./assets/config)

My personal configuration/dotfiles for various tools I use, together with my customisations to various window managers and other usability settings.  

## Highlighted Projects

[<img src = "https://raw.githubusercontent.com/ArenT1981/CSV2OrgSchema/master/assets/logo.png">](https://github.com/ArenT1981/CSV2OrgSchema)

- [**CSV to Org Schema: Apex Code Generator written in Java**](https://github.com/ArenT1981/CSV2OrgSchema)

A Java project that programmatically generates self-contained Salesforce Apex code utilising the Metadata API to fully generate/populate a Salesforce org with custom objects and fields, entirely bypassing the inefficient web interface and providing an easily automated solution. 

[<img src= "https://raw.githubusercontent.com/ArenT1981/bsa_constraint_validation_assign1/master/assets/img/logo.png">](https://github.com/ArenT1981/bsa_constraint_validation_assign1)

- [**NHS BSA Assignment**](https://github.com/ArenT1981/bsa_constraint_validation_assign1)

A Java project that implements a JSR-303 ConstraintValidator Java Bean for checking/validating input values. Complete with full test classes, detailed documentation, full Javadoc and near 100% code coverage via JaCaco.

## [Development Portfolio Projects](./code)

Portfolio of my projects and work (in alphabetical order as per file listing above). Please see each individual project page for detailed information, together with supporting documentation, images, diagrams, and other materials (such as screencasts).  

[<img src="./assets/img/pic-project-banner.png">](./code/PIC-traffic-light)

- [**PIC Microcontroller Pedestrian Crossing/Traffic Light Simulator**](./code/PIC-traffic-light)

Simulates a rudimentary traffic light simulation on the Millennium board using the LEDs and button. Written in embedded **C**. Complete with extensive documentation detailing the design, implementation, and testing process/framework.  

[<img src = "./assets/img/agent-project-banner.png">](./code/agent-maze-searcher)

- [**Agent Maze Searcher**](./code/agent-maze-searcher)

A program written in **Scheme/Racket** that reads in a maze/2D world input from a file, and then presents a valid solution path to the destination/treasure (if it exists). Needs refactoring.  

[<img src="./assets/img/algorithms-banner.png">](./code/algorithms)

- [**Algorithms**](./code/algorithms)

A variety of algorithms I have implemented:

`2happroximation.py` - **Python** script that computes an Eulerian cycle in a graph in linear time whose run-time duration is guaranteed to be, at worst, 2x the duration of an optimal Hamiltonian cycle (for which no known algorithm can compute in linear time complexity).  
`bst-node-count.cpp` - **C++** program that uses a recursive algorithm to calculate the total number of nodes in a binary search tree.  
`dicegame.py` - **Python** script that computes a statistically guaranteed winning strategy (in the long run) based on a one-throw dice game with an arbitrarily large selection of six-sided dice each of which has different scoring weights/probabilistic outcomes.  
`gsmatching.py` - **Python** script implements a solution to the classic so-called "marriage" or "matching" algorithm based on two sets/groups of individuals/entities each of whom has a ranked set of preferences (i.e. a combination) of the other set/group, and pairs them off accordingly until an optimal stable solution is found.  
`insertion-and-merge-sort.cpp` - **C++** snippet that shows implementation to insertion and merge sort algorithms. Insertion sort uses low-level manual pointer manipulation.  
`tree-level-traversal.cpp` - **C++** snippet that shows implementation of a tree level order based traversal using C++ iterator constructs.

[<img src="./assets/img/concept-map-banner.png">](./code/context-weighted-graph)

- [**Context Map/Weight Graph**](./code/context-weighted-graph)

An unfinished program that reads in any number of definition files for a weighted directed graph (concept map) and stores them on the heap. The idea is they can then be used to represent any structured collection of "concepts" or "ideas" that exist in a weighted network. Mostly written as a learning exercise to improve my **C** coding, but thought it worthwhile to include here anyway. In practice, it would be more suited to implementing in an OO language like C++, Python, or Java.  

[<img src="./assets/img/emacs-switch-banner.png">](./code/emacs-switch-and-backup)

- [**Emacs switch and backup**](./code/emacs-switch-and-backup)

A **bash** convenience wrapper/customisation script that automates multiple profile switching using [chemacs](https://github.com/plexus/chemacs) together with a configuration backup. The primary purpose behind this was to ease having both a "stable" (known good) and "development/daily" setup, so that if you should accidentally break your Emacs setup, you would still have a known good setup you could immediately use if you have urgent work pending.  

[<img src="./assets/img/fit-plot-org-mode.png">](./code/fit-plot-org-mode)

- [**Fit Plot Org-Mode**](./code/fit-plot-org-mode) 

A **bash** project that automatically generates plots (Heart Rate, Power, Cadence) using [Gnuplot](http://www.gnuplot.info/) from Garmin `FIT` files that have been converted to `CSV` files. This makes it easy to incorporate the graphs in a workout diary/log (for those of us that like to log outside of Garmin Connect's cloud service!). The script makes use of Max Candocia's Python FIT to CSV conversion script which can be found [here](https://github.com/mcandocia/fit_processing).  

[<img src="./assets/img/java-web-server-banner.png">](./code/java-mt-webserver)

- [**Java Web Server**](./code/java-mt-webserver)

A rudimentary multi-threaded web server written in **Java** that serves static HTML pages and basic MIME content to any connecting web browser or client.  

[<img src="./assets/img/rsync-banner.png">](./code/rsync-incremental-backup)

- [**Rsync + tar incremental backup system**](./code/rsync-incremental-backup) 

A **bash** project that combines standard GNU `tar/gzip` with `rsync` to create an automated incremental backup solution, including a remote destination. Only three paths need to be set (local source, local destination, remote destination) and you have a fully automated backup solution all in place; no complex configuration or options required. Detailed documentation in README file in project directory.  

[<img src="./assets/img/secretary-banner.png">](./code/secretary)

- [**Secretary**](./code/secretary)

A **bash** shell project that automatically tidies, organises and reorders your files. It allows automated file backup/copying/filtering based on a simple input file that specifies a globbing pattern derived from either the file extension or the reported file header metadata.  
 
