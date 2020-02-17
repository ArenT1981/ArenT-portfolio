# dicenumber.py
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2020-02-17
# Version 1.0
#
# This program provides a solution to the following problem:
# How many dice n do I need to throw to maximise my chance of 
# getting precisely x dice - no more, no less?
#
# The algorithm uses a configurable number of rounds to asymtoptically
# approach an ever-greater approximation of the optimal "average"
# rolls (at the expense of greater computation time), a floating point, 
# and more practicably, shows the the top three number of total dice to 
# roll that maximise your probability of getting
# x number of dice all with the same number/face (no more, no less).
#
# Note that rolling a single dice 15 times and counting the occurrences of 
# each side/number is exactly the same as rolling 15 dice simulataneously
# and counting all of the occurrences that way.
#
# Uses numpy as its array performance is considerably superior to appending
# thousands of values into a results list, since we can just statically 
# pre-allocate an array.

from collections import Counter
import numpy as np
import random

# How many rounds. Greater number is more accurate, but slower
# 1 million is pretty accurate (to within 0.001 or so) for matchings
# of five sides, and takes about 2-3 minutes
NUM_OF_GAMES = 1000000
# How many identical numbered/side of dice is our target?
NUM_OF_MATCHES = 6

# Statically allocate array size for better performance
roll_results = np.zeros(NUM_OF_GAMES)

print("Calculating aysmptotic solution across " + str(NUM_OF_GAMES) + " rounds/games. Please wait...")
for x in range(NUM_OF_GAMES):
    
    dice = {"one": 0, "two":0, "three":0, "four":0, "five":0, "six":0}
    
    found_matches = False
    rolls = 0
    
    while found_matches == False:
        # Throw a dice...
        throw = random.randint(1,6)
        #print("Rolling...")
        rolls += 1
        
        # Ugly if/elsif block because Python doesn't have
        # switch / case language construct
        if throw == 1:
            dice["one"] += 1
            if dice["one"] == NUM_OF_MATCHES:
                found_matches = True
        elif throw == 2: 
            dice["two"] = dice["two"] + 1
            if dice["two"] == NUM_OF_MATCHES:
                found_matches = True
        elif throw == 3: 
            dice["three"] = dice["three"] + 1
            if dice["three"] == NUM_OF_MATCHES:
                found_matches = True
        elif throw == 4: 
            dice["four"] = dice["four"] + 1
            if dice["four"] == NUM_OF_MATCHES:
                found_matches = True
        elif throw == 5: 
            dice["five"] = dice["five"] + 1
            if dice["five"] == NUM_OF_MATCHES:
                found_matches = True
        elif throw == 6: 
            dice["six"] = dice["six"] + 1
            if dice["six"] == NUM_OF_MATCHES:
                found_matches = True
        
    #print("Rolls: " + str(rolls))
    
    # Use numpy as much faster than list appending    
    roll_results[x] = rolls
    # Status update for users benefit
    if x % 10000 == 0:
        print("-> [ " + str(x) + " / " + str(NUM_OF_GAMES) + " games (rounds) computed" + " ] ..")
    
# Drum roll...
print
print("=== Results ===")
print
print("Three most common/viable total number of dice to roll to maximise probability of achieving " + str(NUM_OF_MATCHES) + " identical dice/sides and their total number of occurences in the games played/rounds run: ") 
print
print(Counter(roll_results).most_common(3))
print
print("Average number of dice/rolls needed for maximum likelihood of success for precisely ->[" + str(NUM_OF_MATCHES) + "]<- (and no more, no less) identical dice faces: ")
print
final_answer = sum(roll_results)/ float(len(roll_results))
print(final_answer)
print
print("So try rolling " + str(int(round(final_answer))) + " dice.") 