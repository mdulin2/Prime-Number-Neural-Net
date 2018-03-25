#Written by Maxwell Dulin, aka ILY

import random as rand
"""
Generators a list of primes numbers in a range
Args:
    starting(int): the value to start from
    amount(int): the amount of values to search for
    pattern(int): the pattern for iterating over the values

Returns:
    num_list(tuple of (int,int))
    the first item is the number itself
    the second number is whether the number is prime or not
    1 for prime, 0 for even
"""
def gen_num_list(starting,amount,pattern):
    #creates a list
    num_list = list()
    for i in range(starting,starting+amount,pattern):
        #primes
        if( i in Primes()):
            num_list.append((i,1))
            #print i, "Prime!"
        #evens
        else:
            num_list.append((i,0))
            #print i, "Not Prime!"
    return num_list

"""
Generators a list of primes numbers randomly
Args:
    size(int): the maximum size of the number
    amount(int): the amount of values to search for
    split(bool): true for a 50-50 split, false otherwise
Returns:
    num_list(tuple of (int,int))
    the first item is the number itself
    the second number is whether the number is prime or not
    1 for prime, 0 for even
"""
def gen_rand_num_list(size,amount,split):
    #creates a list
    num_list = list()
    count = 0
    spot = 0
    while(count <= amount):
        number = rand.randint(1,size)
        #primes
        if(number in Primes()):
            if(spot == 1 or split == False):
                num_list.append((number,1))
                count +=1
                spot = 0
            #print i, "Prime!"
        #evens
        else:
            if(spot == 0 or split == False):
                num_list.append((number,0))
                count +=1
                spot = 1

            #print i, "Not Prime!"

    return num_list

"""
Creates a number with the amount specified
Args:
    amount(int): the amount of digits to use in the number
Returns:
    num(int): the integer being created
"""
def digit_count(amount):
    num = 1
    for i in range(amount-1):
        num *= 10
    return num

"""
Writes the numbers to a csv file
Args:
    num_list(a list of tuples): In the form (int,int)
        The first int is the number that was checked for primality
        The second int is 1 if prime, 0 otherwise.
    file_name(string): name of the file to output to
"""
def write_to_file(num_list,file_name):
    num_string = ""
    for elt in num_list:
        num_string += str(elt[0]) +"," + str(elt[1]) + '\n'
    #deletes the excess newline character
    num_string = num_string[:-1]

    file_write = open(file_name,"w")
    #headers
    file_write.write("Number,PoC\n")
    #writes all of the information to a file
    file_write.write(num_string)


x = gen_rand_num_list(digit_count(35),20000,False)
#num_list = gen_num_list(digit_count(30),10000,1)
write_to_file(x,"primes_notsplit.csv")
