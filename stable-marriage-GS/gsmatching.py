# Write a Python function stableMatching(n, menPreferences, womenPreferences)
# that gets the number n of women and men, preferences of all women and men, and
# outputs a stable matching.
#
# The function should return a list of length n, where ith element is the number
# of woman chosen for the man number i.def stableMatching(n, menPreferences,
# womenPreferences):

menChoices = dict()
womenChoices = dict()

def setUnmarried(man):
    # Fiance has rejected him, back on the marriage hunt!
    print("setting previous proposal unmarried")
    menChoices["man-"+str(man)] = -1#
    print(menChoices)


def doMarry(flag, choice, man_index, woman_index, current_man, current_woman):

    # Obtain their current marriage status/match
    man_status = menChoices["man-"+str(man_index)]
    woman_status = womenChoices["woman-"+str(woman_index)]

    # Get his next choice 
    wifeChoice = current_man[choice]

    # 1. Base case
    # He's already married, so do nothing...
    if man_status != -1:
        print("Man is already married, skipping.")
        flag = 1
        return flag

    # 2. Second base case. Women not married, so immediately marry
    if woman_status == -1:
        print("Not married. Marrying unmarried man to woman: ", man_index, woman_index)
        print(wifeChoice)
        menChoices["man-"+str(man_index)] = woman_index
        womenChoices["woman-"+str(woman_index)] = man_index
        print(menChoices, womenChoices)
        flag = 1
        # Return married choice immediately from function
        return flag

    print("Married woman, does will she accept?")
    if woman_status != -1:

        print("comparison marriage")
        print(current_man,man_index,woman_index)
        proposing_man = man_index
        print("PROPOSING: ", man_index)
        current_fiance_number = womenChoices["woman-"+str(woman_index)]

        current_fiance = current_woman.index(current_fiance_number)
        proposed_fiance = current_woman.index(proposing_man)

        print("current_fiance index:", current_fiance)
        print("proposing_fiance index:", proposed_fiance)
        #print("woman index:", man.index())

        if proposed_fiance < current_fiance:
            print("she prefers him to", current_fiance_number)
            print("he is:", proposing_man)
            print("his choice: ", wifeChoice)
            print("unmarrying man number: ", current_fiance_number)
            setUnmarried(current_fiance_number)
            menChoices["man-"+str(man_index)] = wifeChoice
            womenChoices["woman-"+str(woman_index)] = man_index
            print("Marriage results:")
            print(menChoices)
            print(womenChoices)
            flag = 1
            return flag
            #print("cf, pf", current_fiance, proposed_fiance)
        else:
            #man.insert(0,wifeChoice)
            print("she rejected him")
            print("cf, pf", current_fiance_number, proposing_man)
            flag = -1
            return flag
    else:
        print("ERROR! Faulty graph")
        flag = -1
        return flag


    print("REACHED here")
    return flag



def stableMatching(n, menPreferences, womenPreferences):

    allMarried = False
    menList = dict()
    womenList = dict()
    marriedList = dict()

    # Final list to return
    choiceList = []

    # initialise
    for x in range(n):
        menChoices["man-"+str(x)] = -1 
        womenChoices["woman-"+str(x)] = -1 
        menList["man-"+str(x)] = menPreferences[x]
        womenList["woman-"+str(x)] = womenPreferences[x]

    # Let's enumerate them with something clearer
    man_number = 0
    manIndex = 0

    all_married = False

    loop_counter = 0


    while all_married == False:

        loop_counter += 1

        for man in range(n):
            flag = -1
            print("man is: " + str(man))
            woman_index = 0
            it = str(woman_index)
            this_man = str(man)
            print("doing: ", str(man))

            while flag != 1:
                #print("inner loop doing: ", str(man), str(womenChoices["woman-"+it]))
                choice = 0
                while woman_index < n:
                    print("woman is: " + str(woman_index))
                    flag = doMarry(flag, choice, man, woman_index, menList["man-"+this_man], womenList["woman-"+it])
                    if flag == 1:
                        break
                    woman_index += 1
                    it = str(woman_index)
                #print("inner loop after: ", str(man), str(womenChoices["woman-"+it]))
                print(womenChoices)

                if flag != 1:
                    choice += 1




        # Debug
        # Show results
        #it = 0
        #for man in range(n):
         #   it = str(man)
          #  print("---")
           # #print("flag: ", flag)
            #print(menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it])
            #print("Man " + str(man) + " is married to woman: " + str(menChoices["man-"+it]))
            #print("---")


        marriedTotal = 0
        print(len(menChoices))
        marriage_check = 0
        for marriage_check in range(len(menChoices)):
            if menChoices["man-"+str(marriage_check)] != -1:
                print("Married!")
                all_married = True
            else:
                print("Not married :-( ")
                all_married = False
                break

        print(menChoices,womenChoices)

        #all_married = True
        #increment += 1
        #debug
        #all_married = True 

    # ====================================================================
    # Loop ends


    # Build final return list
    for man in range(n):
        currentMan = menChoices["man-"+str(man)]
        choiceList.append(currentMan)


    print(menChoices)
    print(womenChoices)

    print("loops: ", loop_counter)
    # Return the final list
    print("Final list: ")
    print(choiceList)

    return choiceList

# def proposeMarriage(flag, index, woman_index, man, woman, man_status, woman_status):
#     print("==================================================")
#     print("Values: ", index,man,woman,man_status,woman_status)
#     print("flag: ", flag)
#     print("index: ", index)
#     wifeChoice = man.pop(0)
#     print("Man: ", man)
#     print("Man wants: ", wifeChoice)
#     print("Woman: ", woman)
#     print("man_status: ", man_status)
#     print("woman_status: ", woman_status)
#     print("woman_index:", woman_index)
# 
#     print("woman: ",woman)
#     print(woman_status)
#     print(wifeChoice)
# 
#     # He's already married, so do nothing...
#     if man_status != -1:
#         print("Man is already married, skipping.")
#         flag = 1
#         return flag, man, woman
# 
#     # Not married, immediately marry
#     if woman_status == -1:
#         print("Not married. Marrying unmarried woman to ", index)
#         man_status = wifeChoice
#         menChoices["man-"+str(index)] = wifeChoice
#         womenChoices["woman-"+str(woman_index)] = index
#         flag = 1
#         # Return results immediately from function
#         return flag, man, woman
# 
#     # ...otherwise, check to see if she if she will accept his
#     # proposal over her existing fiance
# 
#     # Get index (i.e. priority, weighting) of current husband
#     # and compare with index of proposal.
#     # If less than (i.e. further towards the left/head of list)
#     # accept, otherwise reject 
# 
#     print("WOMAN STATUS:", woman_status)
#     if woman_status != -1:
# 
#         print("comparison marriage")
#         print(man,index,woman_status)
#         proposing_man = index
#         current_fiance = woman.index(woman_status)
#         proposed_fiance = woman.index(proposing_man)
#         print("current_fiance index:", current_fiance)
#         print("proposing_fiance index:", proposed_fiance)
#         #print("woman index:", man.index())
# 
#         if proposed_fiance < current_fiance:
#             print("she prefers him to", woman_status)
#             print("he is:", index)
#             print("his choice: ", wifeChoice)
#             setUnmarried(woman_status)
#             woman_status = proposed_fiance
#             man_status = wifeChoice
#             menChoices["man-"+str(index)] = wifeChoice
#             womenChoices["woman-"+str(woman_index)] = index
#             print("FUCK")
#             print(menChoices)
#             print(womenChoices)
#             flag = 1
#             print("cf, pf", current_fiance, proposed_fiance)
#         else:
#             man.insert(0,wifeChoice)
#             print("cf, pf", current_fiance, proposed_fiance)
#     else:
#         print("ERROR! Faulty graph")
#         flag = -100
# 
#     return flag, man, woman
# 
# 
# 
# 
# def stableMatching(n, menPreferences, womenPreferences):
#     # Initially, all n men are unmarried
#     #unmarriedMen = list(range(n))
# 
#     allMarried = False
#     menList = dict()
#     womenList = dict()
# 
#     marriedList = dict()
# 
#     # Final list to return
#     choiceList = []
# 
#     # initialise
#     for x in range(n):
#         menChoices["man-"+str(x)] = -1 
#         womenChoices["woman-"+str(x)] = -1 
#         menList["man-"+str(x)] = menPreferences[x]
#         womenList["woman-"+str(x)] = womenPreferences[x]
# 
# 
#     #print(menChoices, womenChoices)
#     #print(menList, womenList)
#     # generate return list
# 
#     #menChoices.pop("man-0")
#     #print("cl", choiceList[0])
#     #print(menChoices)
# 
#     #for person in range(n): #unmarriedMen:
#         
# 
# 
#     # Let's enumerate them with something clearer
#     man_number = 0
#     manIndex = 0
# 
#     all_married = False
# 
#     loop_counter = 0
# 
#     while all_married == False:
# 
#         loop_counter += 1
#         flag = -1
# 
#         #(flag, menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it]) = proposeMarriage(manIndex, menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it])
#     #    unmarriedMen[man] = "man-" + str(man_number)
#     #    man_number += 1
# 
# 
#         for man in range(n):
#             woman_index = 0
#             it = str(woman_index)
# 
#             man_married = -1
#             this_man = str(man)
#             print("doing: ", str(man))
#             while flag == -1:
#                 print("inner loop doing: ", str(man), str(womenChoices["woman-"+it]))
#                 (flag, menList["man-"+this_man], womenList["woman-"+it]) = proposeMarriage(flag, man, woman_index, menList["man-"+this_man], womenList["woman-"+it], menChoices["man-"+this_man], womenChoices["woman-"+it])
#                 print("inner loop after: ", str(man), str(womenChoices["woman-"+it]))
#                 print(womenChoices)
#                 woman_index += 1
#                 it = str(woman_index)
# 
# 
#             flag = -1
# 
# 
#         # Debug
#         # Show results
#         it = 0
#         for man in range(n):
#             it = str(man)
#             print("---")
#             print("flag: ", flag)
#             print(menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it])
#             print("Man " + str(man) + " is married to woman: " + str(menChoices["man-"+it]))
#             print("---")
# 
# 
#         marriedTotal = 0
#         print(len(menChoices))
#         for marriage_check in range(len(menChoices)):
#             if menChoices["man-"+str(marriage_check)] != -1:
#                 print("Married!")
#                 all_married = True
#             else:
#                 print("Not married :-( ")
#                 all_married = False
#                 break
# 
#         print(menChoices,womenChoices)
# 
# 
#         #increment += 1
#         #debug
#         #all_married = True 
# 
#     # ====================================================================
#     # Loop ends
# 
# 
#     # Build final return list
#     for man in range(n):
#         currentMan = menChoices["man-"+str(man)]
#         choiceList.append(currentMan)
# 
# 
#     print(menChoices)
#     print(womenChoices)
# 
#     print("loops: ", loop_counter)
#     # Return the final list
#     print("Final list: ")
#     print(choiceList)
# 
#     return choiceList


                #print(unmarriedMen)
        # None of the men has a spouse yet, we denote this by the value None
    #manSpouse = [None] * n

    #print(manSpouse)
    # None of the women has a spouse yet, we denote this by the value None
    #womanSpouse = [None] * n

    # Each man made 0 proposals, which means that
    # his next proposal will be to the woman number 0 in his list
    #nextManChoice = [0] * n
    #print(nextManChoice)
    # Let us iterate over male choices

    #for man in menPreferences:
     #   print(man)

    #print(menPreferences)
    # While there exists at least one unmarried man:
#    while unmarriedMen:
#        # Pick an arbitrary unmarried man
#        he = unmarriedMen[0]
#        # Store his ranking in this variable for convenience
#        hisPreferences = menPreferences[he]
#        # Find a woman to propose to
#        she = hisPreferences[nextManChoice[he]]
#        # Store her ranking in this variable for convenience
#        herPreferences = womenPreferences[she]
#        # Find the present husband of the selected woman (it might be None)
#        currentHusband = womanSpouse[she]
#
#        # Write your code here
#
#        # Now "he" proposes to "she". 
#        # Decide whether "she" accepts, and update the following fields
#        # 1. manSpouse
#        # 2. womanSpouse
#        # 3. unmarriedMen
#        # 4. nextManChoice

    # Note that if you don't update the unmarriedMen list, 
    # then this algorithm will run forever. 
    # Thus, if you submit this default implementation,
    # you may receive "SUBMIT ERROR".
#    return manSpouse

# You might want to test your implementation on the following two tests:
# assert(stableMatching(1, [ [0] ], [ [0] ]) == [0])


#assert(stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ]) == [0, 1])


#stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ])
stableMatching(2, [ [0,1], [0,1] ], [ [1,0], [1,0] ])

# stableMatching(5,
#                 [ [3,1,2,0,4],
#                 [4,2,1,0,3], 
#                 [1,4,0,3,2],
#                 [4,1,3,2,0],
#                 [3,0,1,2,4] ],
#                 [ [3,1,4,2,0],
#                 [1,0,3,2,4],
#                 [0,2,4,3,1],
#                 [3,0,2,1,4],
#                 [1,4,0,2,3] ])
