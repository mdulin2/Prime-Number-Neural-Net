import csv

numbersHex = open("numbersHex.csv", 'w')
numbersHexASCII = open("numbersHexASCII.csv", 'w')
numbersBin = open("numbersBin.csv", 'w')
numbersDecASCII = open("numbersDecASCII.csv", 'w')

with open('numbers.csv', 'r') as csvfile:
    data = csv.reader(csvfile, delimiter=',')
    for row in data:
        numbersBin.write(format(int(row[0]), 'b')+','+row[1]+'\n')
        hex = format(int(row[0]), 'X')
        hexASCII = ""
        decASCII = ""
        for c in hex:
            hexASCII+=str(ord(c))
        for c in row[0]:
            decASCII+=str(ord(c))
        numbersDecASCII.write(decASCII+','+row[1]+'\n')
        numbersHex.write(hex+','+row[1]+'\n')
        numbersHexASCII.write(hexASCII+','+row[1]+'\n')

numbersHex.close()
numbersHexASCII.close()
numbersBin.close()
numbersDecASCII.close()