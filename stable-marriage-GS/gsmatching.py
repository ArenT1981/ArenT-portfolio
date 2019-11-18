# Write a Python function stableMatching(n, menPreferences, womenPreferences)
# that gets the number n of women and men, preferences of all women and men, and
# outputs a stable matching.
#
# The function should return a list of length n, where ith element is the number
# of woman chosen for the man number i.def stableMatching(n, menPreferences,
# womenPreferences):


def proposeMarriage(index, man, woman, man_status, woman_status):
    print(man,woman)
    wifeChoice = man.pop(0)
    print(man,woman)
    print(woman_status)
    print(wifeChoice)

    # Not married, immediately marry
    if man_status and woman_status == -1:
        print("Not married")
        man_status = wifeChoice
        woman_status = index

    return man, woman, man_status, woman_status




def stableMatching(n, menPreferences, womenPreferences):
    # Initially, all n men are unmarried
    #unmarriedMen = list(range(n))

    allMarried = False
    menList = dict()
    womenList = dict()

    marriedList = dict()
    menChoices = dict()
    womenChoices = dict()

    # initialise
    for x in range(n):
        menChoices["man-"+str(x)] = -1 
        womenChoices["woman-"+str(x)] = -1 
        menList["man-"+str(x)] = menPreferences[x]
        womenList["woman-"+str(x)] = womenPreferences[x]


    #print(menChoices, womenChoices)
    #print(menList, womenList)
    # generate return list
    #for x in range(n):
     #   currentMan = menChoices["man-"+str(x)]
      #  choiceList.append(currentMan[0])


    #menChoices.pop("man-0")
    #print("cl", choiceList[0])
    #print(menChoices)

    #for person in range(n): #unmarriedMen:
        


    # Let's enumerate them with something clearer
    man_number = 0
    manIndex = 0

    all_married = False

    increment = 0

    while all_married == False:

        it = str(increment)

        (menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it]) = proposeMarriage(manIndex, menList["man-"+it], womenList["woman-"+it], menChoices["man-"+it], womenChoices["woman-"+it])
    #    unmarriedMen[man] = "man-" + str(man_number)
    #    man_number += 1

        print("---")
        print(menList["man-0"], womenList["woman-0"], menChoices["man-0"], womenChoices["woman-0"])


        marriedTotal = 0
        for marriage_check in range(len(menChoices)):
            if menChoices["man-"+str(marriage_check)] != -1:
                print("Married!")
                all_married = True
            else:
                print("Not married :-( ")
                all_married = False
                break


        increment += 1
        #debug
        all_married = True 
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
# assert(stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ]) == [0, 1])


stableMatching(2, [ [0,1], [1,0] ], [ [0,1], [1,0] ])
