# dicegame.py
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2019-11-15
# Version 1.0
#
# This program simulates a "weighted" dice competition between two six
# sided dice, and implements a probabilistically winning strategy, by
# selecting either to go first (if there is a single clear "winning" dice
# to select), or by going second otherwise, always responding with the
# best option to win overall (in the long run, over many rounds).
#
# Each player picks and rolls one dice. Whoever scores highest wins. Equal
# scores means a tie. Depending on the dice, therefore, it is advantageous to
# either deliberately go first (if clear winning dice), or go second otherwise.
# This allows you to maximise your chances probabilistically to win. Obviously
# this scenario only makes sense if we have a range of different weighted dice
# to pick from, rather than just two regular dice with a standard 1-6
# numbering. With regular dice it makes no difference whether you go first or
# second, equal chance either way.
#
# It builds a results table for each pairwise dice comparison, then uses
# this as the basis for building up a dice "score" and then makes an
# appropriate choice.
#
# It builds an array of dictionaries that store the results tables from each
# value comparison per side of side across a pair. As such it can work with any
# arbitrarily long list of dice, though here we are taking them to be 6-sided.
# It would be easy to amend it for any-sided dice, however.

# Compute results table between two dice and return as a 2-tuple

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

# Find which dice beat the given die by the largest margin
def find_weakness(resultlist):
    pick_dice = -1
    margin = -1
    for key in resultlist:
    # Find losses
        if resultlist[key] == 0:
            # Extract losing margin from dictionary field
            if resultlist["LM" + str(key)] > margin:
                pick_dice = key
                margin = resultlist["LM" + str(key)]
    return pick_dice

def check_unique_winning_dice(resultlist):
    # Determine if dice is a unique winner; i.e. beats every single other die
    # probabilistically
    for key in resultlist:
        # Filter out the extra metadata fields with winning/losing margins
        if isinstance(key, (int, long)):
            if resultlist[key] != 1:
                return -1
    return 1

# This function was superseded by the more generalised function below
# which build an array of dictionaries, each one storing the results table
# per dice.
#
# Find the best dice in the instance where there is a unique winning dice that
# probabilistically should beat all of the rest. Return -1 if no such unique die
def find_the_best_dice(dices):

    assert all(len(dice) == 6 for dice in dices)
    winning_dice = -1
    winner = -1
    best_dice = -1

    # Dictionary to store the pairwise comparisons between dice
    winner_dict = [dict() for x in range(len(dices))]

    # Iterate through all the dice and accumulate the results
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

    # Determine if we have a single unique winning dice...
    # If so, select immediately
    for dice_results in range(len(winner_dict)):
        if check_unique_winning_dice(winner_dict[dice_results]) == 1:
            best_dice = dice_results
            return dice_results
    return -1


# Build an array of dictionaries that each store the resultant dice comparison tables
def compute_dice_table(dices):

    winning_dice = -1
    assert all(len(dice) == 6 for dice in dices)
    winner = -1

    # Create the necessary array of empty dictionaries
    winner_dict = [dict() for x in range(len(dices))]

    for dice_index in range(len(dices)):
        dice_comp = 0
        while dice_comp < (len(dices)):
            # Skip the comparison of a die with itself...
            if dice_index == dice_comp:
                dice_comp += 1
                continue
            winner = count_wins(dices[dice_index], dices[dice_comp])

            # Add the results (0 = lost, 1 = win) from each pairwise comparison
            # of the dice sides
            if winner[0] > winner[1]:
                winner_dict[dice_index][dice_comp] = 1
                # Field to store winning margin (useful for determining "best"
                # winning die)
                winner_dict[dice_index]["WM" + str(dice_comp)] = winner[0] - winner[1]
            if winner[0] < winner[1]:
                winner_dict[dice_index][dice_comp] = 0
                # Field to store losing margin
                winner_dict[dice_index]["LM" + str(dice_comp)] = winner [1] - winner[0]
            if winner[0] == winner[1]:
                winner_dict[dice_index][dice_comp] = "tie"

            dice_comp += 1

    best_dice = -1

    # Check to see if there is a unique winning die, mathematically better than all others.
    for dice_results in range(len(winner_dict)):
        if check_unique_winning_dice(winner_dict[dice_results]) == 1:
            best_dice = dice_results

    return (winner_dict, best_dice)

# Main function that initiates the program
def compute_strategy(dices):
    assert all(len(dice) == 6 for dice in dices)

    # Build the dice results table, see if there is a unique winning die
    dice_table,uniquewinner = compute_dice_table(dices)

    strategy = dict()

    # Unique winner? Use it!
    if uniquewinner != -1:
        strategy["choose_first"] = True
        strategy["first_dice"] = uniquewinner
    else:
        # No unique winner, build combat strategy
        strategy["choose_first"] = False
        for i in range(len(dices)):
            # Initialise
            strategy[i] = (i + 1) % len(dices)
            # Find our "killer" die to use
            killdie = find_weakness(dice_table[i])
            if killdie != -1:
                strategy[i] = killdie
            else:
                print("No viable option found.")

    return strategy


# Test output with some dice
# ============================================================================
# Output explanation:
# 'choose_first': if True, go first, since we know the best die to immediately
# pick
# 'first_dice': the actual dice we pick, maximum chance of winning. Index
# starts at 0
#
# Otherwise:
# 'choose_first': False
# Show pairwise responses based on the dice number the opponent picked.
# e.g. if they pick dice 1, and dice 2 is the best option to counter with, the
# result will look like this:
# {1: 2, 'choose_first': False}
# ===========================================================================

print(compute_strategy([[1, 1, 4, 6, 7, 8], [2, 2, 2, 6, 7, 7], [3, 3, 3, 5, 5, 8]]))
print(compute_strategy([[4, 4, 4, 4, 0, 0], [7, 7, 3, 3, 3, 3], [6, 6, 2, 2, 2, 2], [5, 5, 5, 1, 1, 1]]))
print(compute_strategy([[1, 1, 6, 6, 8, 8], [2, 2, 4, 4, 9, 9], [3, 3, 5, 5, 7, 7]]))
print(compute_strategy([[1, 1, 2, 4, 5, 7], [1, 2, 2, 3, 4, 7], [1, 2, 3, 4, 5, 6]]))
print(compute_strategy([[3, 3, 3, 3, 3, 3], [6, 6, 2, 2, 2, 2], [4, 4, 4, 4, 0, 0], [5, 5, 5, 1, 1, 1]]))

