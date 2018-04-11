import csv

source = "numbersBin.csv"
destination = open("padded" + source, 'w')
paddingNeeded = 0
knowsPadding = False
with open(source, 'r') as csvfile:
    data = csv.reader(csvfile, delimiter=',')
    destination.write("Binary,Prime\n")
    for row in data:
        #get number of chars in first object
        if(not knowsPadding):
            #the size of each section is of a semi variable length, because of the transition from decimal to binary.
            paddingNeeded = len(row[0])+3
            knowsPadding = True
            destination.write(row[0]+","+row[1]+"\n")
        else:
            #adds zeros at beginning to make all strings the same length
            padding = "0" * (paddingNeeded-len(row[0]))
            padding += row[0]
            destination.write(padding+","+row[1]+"\n")

print(str(paddingNeeded))
destination.close()
