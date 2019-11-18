# gsmatching.py
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2019-11-18
# Version 1.0
#
# ==============================================================================
# This program implements the Gale-Shapely matching algorithm, commonly called
# the "marriage" algorithm, that is use in the real world to match candidate
# choices with institutions, for example.
#
# Given two input tables, where each row consists of the ordered preference for
# that particular person/entity/thing (A) among a set of choices, and a
# corresponding table from the receiving person/entity/thing (B) with their ordered
# preferences of choices, this algorithm maximally matches the proposals made
# by A based on their preferences with those of B.
#
# For example, a prospective student may list their chosen institutions to study
# at, and the institution may keep a corresponding list of their chosen students
# by preference, and this algorithm will match them pairwise with the best
# possible compromise option available (though biased towards the chooser, in
# this case the "men" proposing to the "women").
# This implementation is also limited in that it only deals with a symmetric data
# set of equally sized A + B with consistent and ordered preferences, i.e. each
# row has a full set of preferences from their best option to their worst
# option, and their are no clashes or other erroneous problems.
#
# Adding this checking logic would require extending the implementation here.
# ==============================================================================
#
# Global data structures:
# Male + female current matches, and the input lists of preferences

menChoices = dict()
womenChoices = dict()
menList = dict()
womenList = dict()

# Break up a match
def setUnmarried(man):
    # She breaks up with him...
    menChoices["man-"+str(man)] = -1#


# Do the actual matching 
def doMarry(flag, choice_index, man):
    # Get his list of prospective suitors
    his_list = menList["man-"+str(man)]
    # Obtain their current marriage status/match
    man_status = menChoices["man-"+str(man)]
    # Get his next choice
    wifeChoice = his_list[choice_index]
    # Ger her list of suitors
    her_list = womenList["woman-"+str(wifeChoice)]
    # Get status of this woman
    woman_status = womenChoices["woman-"+str(wifeChoice)]


    print("Man " + str(man) + " is proposing to woman " + str(wifeChoice))
    # 1. Base case
    # He's already married, so do nothing...
    if man_status != -1:
        print("Man is already engaged and should not be proposing to anyone else, naughty man!")
        flag = 1
        return flag

    # 2. Second base case. Women not married, so immediately marry
    if woman_status == -1:
        print("His choice is not engaged. Engaging single man " + str(man) + " to woman " + str(wifeChoice))
        menChoices["man-"+str(man)] = wifeChoice
        womenChoices["woman-"+str(wifeChoice)] = man
        flag = 1
        # Return married choice immediately from function
        return flag

    # 3. She's with someone - but will she ditch them to be with him?
    print("Engaged woman, will she accept his proposal?")
    if woman_status != -1:

        current_fiance_number = womenChoices["woman-"+str(wifeChoice)]

        current_fiance = her_list.index(current_fiance_number)
        proposed_fiance = her_list.index(man)

        if proposed_fiance < current_fiance:
            # She accepts his proposal as he is a better option
            print("Proposal accepted. Woman " + str(wifeChoice) + " is rejecting man " + str(current_fiance_number) + " to become engaged to man " + str(man))
            setUnmarried(current_fiance_number)
            menChoices["man-"+str(man)] = wifeChoice
            womenChoices["woman-"+str(wifeChoice)] = man
            flag = 1
            return flag
        else:
            # Proposal rejected, he will have to try again with someone else...
            print("Woman " + str(wifeChoice) + " rejected his proposal, prefers to be with man " + str(current_fiance_number))
            flag = -1
            return flag
    else:
        # Something is not right in the initial data, whoops!!!
        print("ERROR! Faulty suitor matching data with errant matchings, cannot compute.")
        print("Looks like they'll just have to stay single for a while longer.")
        flag = -100
        return flag

    return flag


# Call the doMarry function on each appropriate man until they are all engaged
def stableMatching(n, menPreferences, womenPreferences):

    # No one is married/engaged yet...
    all_married = False

    # Final list to return
    choiceList = []

    # Initialise data structures
    for x in range(n):
        menChoices["man-"+str(x)] = -1 
        womenChoices["woman-"+str(x)] = -1 
        menList["man-"+str(x)] = menPreferences[x]
        womenList["woman-"+str(x)] = womenPreferences[x]

    # Let's see how many iterations are required to fully pairwise match everyone
    loop_counter = 0


    # Keep going until everyone is matched up
    while all_married == False:

        loop_counter += 1

        for man in range(n):
            # Flag indicates engagement success (or not)
            flag = -1
            choice_index = 0
            woman_index = 0
            it = str(woman_index)
            this_man = str(man)

            while flag != 1:
                # While the proposal is not successful...
                while woman_index < n:
                    flag = doMarry(flag, choice_index, man)
                    if flag == 1:
                        # Great, found a match
                        break
                    woman_index += 1
                    it = str(woman_index)

                    if flag != 1:
                        # No match for that choice, onto his next choice
                        choice_index += 1

                    if flag == -100:
                        # Something is not right in the input data...
                        all_married = True
                        print("Errors encountered on input matching data, please check and try again.")

        # Check to see whether we have now matched everyone
        marriage_check = 0
        for marriage_check in range(len(menChoices)):
            if menChoices["man-"+str(marriage_check)] != -1:
                # Found a married pair, set flag
                all_married = True
            else:
                # At least one suitor is still not matched, keep going with
                # another iteration 
                print("Some suitors are still single :-( ")
                print("Let's find them someone to be with.")
                all_married = False
                break

    # ====================================================================
    # While loop ends here


    # Build final return list
    for man in range(n):
        currentMan = menChoices["man-"+str(man)]
        choiceList.append(currentMan)

    # Print out the results
    print("=============================")
    print("Here are the final matchings:")
    print("Men's choices: " + str(menChoices))
    print("Women's choices: " + str(womenChoices))
    print("Loops required to compute: " + str(loop_counter))

    # Return the final list
    print("Final list: ")
    print(choiceList)
    print("=============================")
    return choiceList


# Some test values
assert(stableMatching(1, [ [0] ], [ [0] ]) == [0])
assert(stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ]) == [0, 1])


stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ])
stableMatching(2, [ [0,1], [0,1] ], [ [1,0], [1,0] ])

stableMatching(5,
                [ [3,1,2,0,4],
                [4,2,1,0,3],
                [1,4,0,3,2],
                [4,1,3,2,0],
                [3,0,1,2,4] ],
                [ [3,1,4,2,0],
                [1,0,3,2,4],
                [0,2,4,3,1],
                [3,0,2,1,4],
                [1,4,0,2,3] ])
