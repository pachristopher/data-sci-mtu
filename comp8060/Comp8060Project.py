# import necessary libraries 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import sys

# read in the datasets
demo = pd.read_csv("NhanesDemoAdapted.csv")

diet = pd.read_csv("NhanesFoodAdapted.csv")

# set up new df for option 3 of main menu on educational attainment
edulabs = ['<9th Grade','9th-11th Grade','High School Graduate','Some College','College graduate or above']
edulabs_dict = dict(enumerate(edulabs, 1)) # create dict to map edu factor index to meaningful names
cleandf = demo[demo['Education']>=1][['Education','HouseholdIncome','IncomePovertyRatio']].dropna()

def intromenu(): # print menu, parse input for errors and return input to main()
    try:
        print("Please select one of the following options: \n")
        print("1. Household income per ethnicity")
        print("2. Marital status")
        print("3. Income and education level")
        print("4. Diet analysis")
        print("5. Exit")
        choice = int(input())
        while not (1 <= choice <= 5):
            print("\nNot a valid choice, enter a number between 1 & 5\n")
            choice = int(input())
        return choice
    except ValueError:
        print(" Input error. You should enter a number between 1 and 5.\n\n")


def chosen(choice): # process user choice and branch to relevant part of program
    if (choice == 1):
        choice1()
    elif (choice == 2):
        choice2()
    elif (choice == 3):
        choice3()
    elif (choice == 4):
        choice4()
    elif (choice == 5):
        print("Exiting program.")

def choice1():
    """ function to process output in respect of option 1 of main menu"""
    print("Number of ethnicities in the dataset:", len(demo['Ethnicity'].unique()))
    print("Number of respondents per ethnicity:")
    print(demo['Ethnicity'].value_counts()) # power of pandas - automatically creates the required output
    ax = sns.barplot(y='Ethnicity', x='HouseholdIncome', data=demo.fillna(method='ffill'), estimator=np.median)
    ax.set(xlabel='Median Income [1000s $]') # default x axis label won't do, y is fine
    ax.figure.set_size_inches(14,4)
    plt.show()

def choice2():
    """function to process output in respect of option 2 of main menu"""
    print("Number of respondents per marital age category")
    marlabs = ['Married', 'Widowed', 'Divorced', 'Separate', 'Single', 'Living with Partner']
    marlabs_dict = dict(enumerate(marlabs, 1)) # create dict to map factor index to descriptive names
    print(demo['Marital Status'].value_counts().rename(index=marlabs_dict)) # apply to counts
    # create df of quartiles to prepare for line plot
    quarts = demo.groupby('Marital Status')['Age'].describe()[['25%','50%','75%']].rename(index=marlabs_dict)
    # Do the plotting
    fig, ax = plt.subplots()
    sns.lineplot(x=quarts.index, y='25%', data=quarts, label='1st quartile')
    sns.lineplot(x=quarts.index, y='50%', data=quarts, label='2nd quartile')
    sns.lineplot(x=quarts.index, y='75%', data=quarts, label='3rd quartile')
    ax.set(ylabel='Age', title='Age Distribution by Marital Status')
    leg = ax.legend()
    plt.show()

def choice3():
    """function to process option 3 by providing its sub-menu and passing
    off to sub-choice function for processing"""
    print("Which variable do you wish to plot against educational attainment?")
    print("1. Income Poverty Ratio\n2. Household Income")
    try:
        choice = int(input())
        while not (1 <= choice <= 2):
            print("Not a valid choice. Choose the number 1 or 2")
            choice = int(input())
        if (choice == 1):
            choice3_1()
        elif (choice == 2):
            choice3_2()
    except ValueError:
        print("\nMust be an integer between 1 and 2. Returning to main menu.\n\n")

def choice3_1():
    # create our df for plotting
    df3_1 = cleandf.groupby('Education')['IncomePovertyRatio'].describe().rename(index=edulabs_dict)
    # create the plot
    ax = sns.barplot(x=df3_1.index, y='mean', data=df3_1)
    ax.set_xticklabels(ax.get_xticklabels(), rotation=30, fontsize=6)
    ax.set(ylabel='Poverty/Income Ratio', title='Mean Poverty/Income Ratio by Educational Attainment')
    plt.show()

def choice3_2():
    # create our df for plotting
    df3_1 = cleandf.groupby('Education')['HouseholdIncome'].describe().rename(index=edulabs_dict)
    # create the plot
    ax = sns.barplot(x=df3_1.index, y='mean', data=df3_1)
    ax.set_xticklabels(ax.get_xticklabels(), rotation=30, fontsize=6)
    ax.set(ylabel='Income [$1000s]', title='Mean Household Income by Educational Attainment')
    plt.show()

def choice4():
    mymerge(demo, diet)
    global merged # declare merged object as global so other functions can access it
    merged = pd.read_csv('merged.csv')
    menu4()

def mymerge(left, right):
    """ function to reduce nutrients dataframe, merge it with demo
    dataframe and then output it to csv file"""
    reduced = right.groupby('SEQN').mean()
    mymerged = pd.merge(left, right, on='SEQN', how='inner')
    mymerged.to_csv('merged.csv')

def menu4():
    """ function to print sub-menu for option 4 in main menu, ensure choice is valid
    and pass choice to next function for plotting"""
    nutrients = ['dGRMS','dKCAL','dPROT','dCARB','dSUGR','dFIBE','dTFAT','dSFAT','dCHOL','dVITC','dVITD','dCALC','dCAFF','dALCO']
    nutrient_dict = dict(enumerate(nutrients,1)) # create dictionary of nutrients
    print("\nThe following nutrients are available:")
    for key, value in nutrient_dict.items():
        print(key, value)
    print("\nWhich Category do you wish (please enter the number)\n")
    choice = input()
    while not choice.isdigit() or not (1 <= int(choice) <= 14): # input validity checking
        print("\nNot a valid choice. Enter a number between 1 and 14.\n")
        choice = input()
    choice = int(choice)
    plots4(nutrient_dict[choice]) # plot user choice of nutrient

def plots4(nutrient):
    """ Function to generate and output plots required for option 4 of main
    menu. Takes one of the 15 particular nutrient types listed in sub-menu 4 as
    input, based on user choice, and feeds this input as paramater to plotting
    functions."""
    # boxplots using seaborn
    ax= sns.boxplot(x='Gender', y=nutrient, data=merged, hue='Ethnicity')
    ax.set_title('Boxplot of '+str(nutrient)+' by Gender and Ethnicity')
    plt.show()
    merged['Education'] = merged['Education'].replace(edulabs_dict) # change legend titles using our dict
    ax2 = sns.boxplot(x='Gender', y = nutrient, data=merged,
    hue='Education')
    ax2.set_title('Boxplot of '+str(nutrient)+' by Gender and Educational Attainment')
    plt.show()
    # scatterplots using matplotlib
    plt.scatter(merged['HouseholdIncome'], merged[nutrient], s=9, c='r',
    alpha=0.5, label='Income')
    plt.scatter(merged['Age'], merged[nutrient], s=9, c='g', alpha=0.5,
    label='Age')
    plt.title('Household Income and Age vs. '+str(nutrient)+' Content of Meal')
    plt.xlabel('Age [yrs] and Income [$ 1000s]')
    plt.ylabel(str(nutrient)+' Content of meal [gm]')
    plt.legend(loc='upper right')
    plt.show()

def main():
    while True:
        choice = intromenu()
        chosen(choice)
        if (choice == 5):
            sys.exit("Thank you. Please call again.")

main()