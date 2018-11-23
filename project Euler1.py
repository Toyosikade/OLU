######################################################################
# Name: Oluwatoyosi Kade
# Date: 11/23/18
# Description: This is the solution to the first project euler question
# it sums up all the values less than 1000 that are divisible by 3 or 5
#######################################################################


#Project Euler1#
Sum = 0                      #Sum is initially set to 0
for i in range(1000):        # for the different values of i less than 1000
    if (i%3 == 0 or i%5==0): # if i is perfectly divisible by 5 or 3
        Sum = i + Sum        # the value of i is then added to the current value of sum
print(Sum)                   # sum is printed


