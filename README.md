# Aren's Development Portfolio

![](./img/portfolio-banner.png)

## [Learning Log](./daily-log.org) 

See my [daily log](./daily-log.org) for a detailed time-tracked summary of my learning. This also reflects my **attention to detail**, **organisation/project management skills**, and above all, **work ethic/consistency**.  

## [Academic & (non-IT specific) Technical Writing](./Academic-and-Technical-Writing-examples)

This contains a representative sample of the quality of my general writing and documentation ability. A detailed summary is presented inside the README inside the directory. Though not IT specific, I feel it is very important to include it in this portfolio because software engineering is about *far* more than just writing code; the production of clear, high quality, and professional documents is crucial.  

## Development Portfolio Projects

Portfolio of my projects and work (in alphabetical order as per file listing above).  

- [PIC Microcontroller Pedestrian Crossing/Traffic Light Simulator](./PIC-traffic-light)

Simulates a rudimentary traffic light simulation on the Millennium board using the LEDs and button. Written in embedded **C**. Complete with extensive documentation detailing the design, implementation, and testing process/framework.  

- [Agent Maze Searcher](./agent-maze-searcher)

A program written in **Scheme/Racket** that reads in a maze/2D world input from a file, and then presents a valid solution path to the destination/treasure (if it exists). Needs refactoring.  

- [Algorithms](./algorithms)

A variety of algorithms I have implemented:

`2happroximation.py` - **Python** script that computes an Eulerian cycle in a graph in linear time whose run-time duration is guaranteed to be, at worst, 2x the duration of an optimal Hamiltonian cycle (for which no known algorithm can compute in linear time complexity).  
`bst-node-count.cpp` - **C++** program that uses a recursive algorithm to calculate the total number of nodes in a binary search tree.  
`dicegame.py` - **Python** script that computes a statistically guaranteed winning strategy (in the long run) based on a one-throw dice game with an arbitrarily large selection of six-sided dice each of which has different scoring weights/probabilistic outcomes.  
`gsmatching.py` - **Python** script implements a solution to the classic so-called "marriage" or "matching" algorithm based on two sets/groups of individuals/entities each of whom has a ranked set of preferences (i.e. a combination) of the other set/group, and pairs them off accordingly until an optimal stable solution is found.  
`insertion-and-merge-sort.cpp` - **C++** snippet that shows implementation to insertion and merge sort algorithms. Insertion sort uses low-level manual pointer manipulation.  
`tree-level-traversal.cpp` - **C++** snippet that shows implementation of a tree level order based traversal using C++ iterator constructs.

- [My Configuration/Linux Setup](./config)

My personal configuration/dotfiles for various tools I use, together with my customisations to various window managers and other usability settings.  

- [Emacs switch and backup](./emacs-switch-and-backup)

A **bash** convenience wrapper/customisation script that automates multiple profile switching using [chemacs](https://github.com/plexus/chemacs) together with a configuration backup. The primary purpose behind this was to ease having both a "stable" (known good) and "development/daily" setup, so that if you should accidentally break your Emacs setup, you would still have a known good setup you could immediately use if you have urgent work pending.  

- [Fit Plot Org-Mode](./fit-plot-org-mode) 

A **bash** project that automatically generates plots (Heart Rate, Power, Cadence) using [Gnuplot](http://www.gnuplot.info/) from Garmin `FIT` files that have been converted to `CSV` files. This makes it easy to incorporate the graphs in a workout diary/log (for those of us that like to log outside of Garmin Connect's cloud service!). The script makes use of Max Candocia's Python FIT to CSV conversion script which can be found [here](https://github.com/mcandocia/fit_processing).  

- [Java Web Server](./java-mt-webserver)

A rudimentary multi-threaded web server written in **Java** that serves static HTML pages and basic MIME content to any connecting web browser or client.  

- [Rsync + tar incremental backup system](./rsync-incremental-backup) 

A **bash** project that combines standard GNU `tar/gzip` with `rsync` to create an automated incremental backup solution, including a remote destination. Only three paths need to be set (local source, local destination, remote destination) and you have a fully automated backup solution all in place; no complex configuration or options required. Detailed documentation in README file in project directory.  

- [Secretary](./secretary)

A **bash** shell project that automatically tidies, organises and reorders your files. It allows automated file backup/copying/filtering based on a simple input file that specifies a globbing pattern derived from either the file extension or the reported file header metadata.  
