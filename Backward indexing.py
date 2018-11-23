#############################################
#Name: Oluwatoyosi Kade
#Date: 11/23/18
#Description: this program requests for a 6 letter word and it uses backward
#indexing to print out the output in reverse. 
#
#################################################


word = input("please enter a 6 letter word:") #this is a prompt it asks for an input and stores it in word
#since the form of indexing used is the backward indexing the the last character is -1 
char1 = word[-1] # the last character in the given word is stored in char1
char2= word[-2] #  the second to the last character in the given word is stored in char2
char3 = word[-3] # the forth character in the given word is stored in char3
char4= word[-4]  # the third   character in the given word is stored in char4
char5 = word[-5] # the  second  character in the given word is stored in char5
char6= word[-6]  # the first character in the given word is stored in char6

 #this prints out the values stored in each character. 
print (char1) 
print (char2)
print (char3)
print (char4)
print (char5)
print (char6)
