#E1 = 1 * 1/6 + 1* 1/6 + 6 * 1/6 + 6 * 1/6 + 8 * 1/6 + 8 * 1/6 =
#     1/6 + 1/6 + 1 + 1 + 8/6 + 8/6 = 5

#E2 = 2 * 1/6 + 2 * 1/6 + 4 * 1/6 + 4 * 1/6 + 9 * 1/6 + 9 * 1/6=
#     2/6 + 2/6 + 4/6 + 4/6 + 9/6 + 9/6 = 5


def count_wins(dice1, dice2):
    assert len(dice1) == 6 and len(dice2) == 6
    dice1_wins, dice2_wins = 0, 0
    ties = 0

    for i in range(len(dice1)):
        for j in range(len(dice2)):
            if dice2[j] > dice1[i]:
                dice2_wins += 1
            elif dice2[j] < dice1[i]:
                dice1_wins += 1
            else:
                ties += 1
    return (dice1_wins, dice2_wins)


#print(count_wins([1,2,3,4,5,6], [1,2,3,4,5,6]))
#print(count_wins([1,1,6,6,8,8], [2,2,4,4,9,9]))

def find_weakness(resultlist):
    win_match = []
    pick_dice = -1
    margin = -1
    #print("rr", resultlist)
    for key in resultlist:
#        print ("key: ", resultlist[key])
        if resultlist[key] == 0:
            if resultlist["LM" + str(key)] > margin:
                pick_dice = key
                margin = resultlist["LM" + str(key)]
                #print("MARGIN: ", margin)
            #win_match.append(key)
            #return key
   # if win_match == []:
    #print("Would return: ", pick_dice)
    return pick_dice

def check_unique_winning_dice(resultlist):
    #print(resultlist)
    for key in resultlist:
        if isinstance(key, (int, long)):
            if resultlist[key] != 1:
                return -1
    return 1



def find_the_best_dice(dices):

    winning_dice = -1
    assert all(len(dice) == 6 for dice in dices)

    #beat_all_others = -1
    winner = -1 
    winner_dict = [dict() for x in range(len(dices))]

    for dice_index in range(len(dices)):
        dice_comp = 0
        while dice_comp < (len(dices)):
            if dice_index == dice_comp:
                dice_comp += 1
                continue
            winner = count_wins(dices[dice_index], dices[dice_comp])
            if winner[0] > winner[1]:
                winner_dict[dice_index][dice_comp] = 1
            elif winner[1] < winner [0]:
                winner_dict[dice_index][dice_comp] = 0
            else:
                winner_dict[dice_index][dice_comp] = "tie"

            dice_comp += 1

    # print(winner_dict[0])
    # print(winner_dict[1])
    # print(winner_dict[2])

    # print("results")
    # print(check_unique_winning_dice(winner_dict[0]))
    # print(check_unique_winning_dice(winner_dict[1]))
    # print(check_unique_winning_dice(winner_dict[2]))
    # print("end reults")


    best_dice = -1
    for dice_results in range(len(winner_dict)):
        if check_unique_winning_dice(winner_dict[dice_results]) == 1:
            best_dice = dice_results
 #           print("Best dice is " + str(dice_results) + " with following results:")
  #          print(winner_dict[dice_results])
   #         print("Dice is: " + str(dices[dice_results]))
            return dice_results
    return -1

def compute_dice_table(dices):

    winning_dice = -1
    assert all(len(dice) == 6 for dice in dices)

    #beat_all_others = -1
    winner = -1 
    winner_dict = [dict() for x in range(len(dices))]

    for dice_index in range(len(dices)):
        #print len(dices)
        #print("di ", dice_index)
        dice_comp = 0
        while dice_comp < (len(dices)):
            #print("dc ", dice_comp)
            if dice_index == dice_comp:
                dice_comp += 1
                continue
            winner = count_wins(dices[dice_index], dices[dice_comp])
            #print(winner)
            if winner[0] > winner[1]:
                winner_dict[dice_index][dice_comp] = 1
                winner_dict[dice_index]["WM" + str(dice_comp)] = winner[0] - winner[1]
            if winner[0] < winner[1]:
                winner_dict[dice_index][dice_comp] = 0
                winner_dict[dice_index]["LM" + str(dice_comp)] = winner [1] - winner[0]
            if winner[0] == winner[1]:
                winner_dict[dice_index][dice_comp] = "tie"

            dice_comp += 1

    best_dice = -1

    for dice_results in range(len(winner_dict)):
        if check_unique_winning_dice(winner_dict[dice_results]) == 1:
            best_dice = dice_results

    return (winner_dict, best_dice)

#    return print(winner_dict[0])

def compute_strategy(dices):
    assert all(len(dice) == 6 for dice in dices)

    dice_table,uniquewinner = compute_dice_table(dices)

    #print("DT: ", dice_table)
    #print(dices)
    strategy = dict()
    
    if uniquewinner != -1:
        strategy["choose_first"] = True
        strategy["first_dice"] = uniquewinner
        #print(strategy["first_dice"])
    else:
        # no unique winner, build combat strategy
        strategy["choose_first"] = False
        for i in range(len(dices)):
            strategy[i] = (i + 1) % len(dices)
            #print("iter ", i)
            killdie = find_weakness(dice_table[i])
            if killdie != -1:
                # Only one better dice?
               # if len(killdie) == 1:
                #    print("foo")
                 #   strategy[i] = killdie[0]
                #else:
                    # Find best possible dice, probabilistically
                 #   kill_list = []
                  #  print("KD: ", killdie)
                    #v=list(killdie.values())
                    #for option in range(len(killdie)):
                       # kill_list.append(dice_tabale[i]["WM" + str()]
                    #for i in range(len(killdie)):
                      #  count_wins
                    # print("for dice "+ str(i) + " play dice: ", killdie)
                strategy[i] = killdie

        #print strategy
#        print(strategy)
    #print("weakness:")
    #weakness = find_weakness(dice_table[1])
    #print(weakness, dices[1])
    return strategy



#print(count_wins([1,2,3,4,5,6], [1,2,3,4,5,6]))
# print(find_the_best_dice([[1, 1, 6, 6, 8, 8], [2, 2, 4, 4, 9, 9], [3, 3, 5, 5, 7, 7]]))
# print(find_the_best_dice([[1, 1, 2, 4, 5, 7], [1, 2, 2, 3, 4, 7], [1, 2, 3, 4, 5, 6]]))
# print(find_the_best_dice([[3, 3, 3, 3, 3, 3], [6, 6, 2, 2, 2, 2], [4, 4, 4, 4, 0, 0], [5, 5, 5, 1, 1, 1]]))


print(compute_strategy([[1, 1, 4, 6, 7, 8], [2, 2, 2, 6, 7, 7], [3, 3, 3, 5, 5, 8]]))
print(compute_strategy([[4, 4, 4, 4, 0, 0], [7, 7, 3, 3, 3, 3], [6, 6, 2, 2, 2, 2], [5, 5, 5, 1, 1, 1]]))
print(compute_strategy([[1, 1, 6, 6, 8, 8], [2, 2, 4, 4, 9, 9], [3, 3, 5, 5, 7, 7]]))
print(compute_strategy([[1, 1, 2, 4, 5, 7], [1, 2, 2, 3, 4, 7], [1, 2, 3, 4, 5, 6]]))
print(compute_strategy([[3, 3, 3, 3, 3, 3], [6, 6, 2, 2, 2, 2], [4, 4, 4, 4, 0, 0], [5, 5, 5, 1, 1, 1]]))
