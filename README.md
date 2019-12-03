# Portfolio

Portfolio of my projects and work (in alphabetical order as per file listing above).  

- [PIC Microcontroller Traffic Light Simulator](./PIC-traffic-light)

Simulates a rudimentary traffic light simulation on the Millennium board using the LEDs and button. Written in embedded C.  

- [Agent Maze Searcher](./agent-maze-searcher)

A program written in Scheme/Racket that reads in a maze/2D world input from a file, and then presents a valid solution path to the destination/treasure (if it exists).  

- [Algorithms](./algorithms)

A variety of algorithms I have implemented:

`2happroximation.py` - This **Python*** script computes an Eulerian cycle in a graph in linear time whose run-time duration is guaranteed to be, at worst, 2x the duration of an optimal Hamiltonian cycle (for which no known algorithm can compute in linear time complexity).  
`bst-node-count.cpp` - A **C++** program that uses a recursive algorithm to calculate the total number of nodes in a binary search tree.  
`dicegame.py` - **Python** script that computes a statistically guaranteed winning strategy (in the long run) based on a dice throw game with a selection of six-sided dice with different scoring weights.  
`gsmatching.py` - This **Python** script implements a solution to the classic so-called "marriage" or "matching" algorithm based on two sets/groups of individuals/entities each of whom has a ranked set of preferences (i.e. a combination) of the other set/group, and pairs them off accordingly until an optimal stable solution is found.  

- [My Configuration/Linux Setup](./config)

My personal configuration/dotfiles for various tools I use, together with my customisations to various window managers and other usability settings.  

- [Emacs backup and switch](./emacs-backup-and-switch)

A convenience wrapper/customisation script that automates moving [space]macs to a custom directory, creating a read-only backup, and then using [chemacs](https://github.com/plexus/chemacs) to effortlessly be able to switch between different Emacs installations/setups. The primary purpose behind this was to ease having both a "stable" (known good) and "development/daily" setup, so that if you accidentally broke your Emacs setup, you'd still have a known good setup you could immediately use until you have time to fix whatever issue you've introduced in your latest update.  

- [Fit Plot Org-Mode](./fit-plot-org-mode) A bash project that automatically generates plots (Heart Rate, Power, Cadence)using GNU plot from Garmin FIT files that have been converted to CSV files. The script makes use of Max Candocia's Python conversion FIT to CSV script which can be found [here](https://github.com/mcandocia/fit_processing).  

- [Java Web Server](./java-mt-webserver)

A rudimentary multi-threaded web server written in Java that serves static HTML pages and basic MIME content to any connecting web browser or client.  

- [Rsync + tar incremental backup system](./rsync-incremental-backup) A bash project that combines standard GNU tar/gzip with rsync to create an automated incremental backup solution, including a remote destination. Only three paths need to be set (local source, local destination, remote destination) and you have a fully automated backup solution all in place; no complex configuration or options required.  

- [Secretary](./secretary)

A bash shell project that automatically tidies, organises and reorders your files. It allows automated file backup/copying/filtering based on a simple input file that specifies a globbing pattern derived from either the file extension or the reported file header metadata.  
