#this program calculates a person's BMI 

weight = float(input ("please enter your weight in Kilogrammes: ") )
Name = input ("please enter your name: ") 
Age = float(input ("how old are you?"))
Height = float(input ("how tall are you in meters?: "))
#Height1 = int(Height* Height)
BMI =  (Weight / (Height*Height))
print ("Dear " +  Name + " at age "+ str(Age) + " your BMI would be " + str(BMI))
