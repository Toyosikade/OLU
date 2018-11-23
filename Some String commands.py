##################################################################################################################
#Name: Oluwatoyosi Kade
#Date: 11/23/2018
#Description: This file contains and some string commands with detailed explanation and examples of how they work. 
###################################################################################################################


# the statement below is used to get the length of a string.
# the quotation mark is needed because it is a string afterall and quotation marks are needed to identify a string.

print (len("string"))

#########################################################################################################################################

# to print out only a specific chunk from the string we have:
print (string[2:8])

# the above statement prints out a list that starts from the second index and ends
#at the 7th index

# E.G

print("Example 1: ")

Word = "Singingiswhatidobest"   #a given string is assigned to word
print(word[0:5])                #this prints out the the character in the first index up to the forth index

print("Example 2: ")
index = 7                   #7 is assigned to index 
print(word[index:9])        #the prints the characters from index 7 to 9, 9 included 

print("Example 3: ")       
print(word[0:])            #this prints all of the characters in the string
print(word[:])             # beacuse where to start and end wasnt specified, the whole string is printed out.
print(word[:9])            # this prints out all the characters stored in each index including the 9th index then it stops.
        
