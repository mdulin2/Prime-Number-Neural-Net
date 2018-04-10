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
def single_gen_num_list(starting, pattern):
    #creates a list
    num_list = list()
    #gets the amount of digits in the number
    length = len(str(starting))
    #creates the cap for the iteration.
    amount = get_num_size(length)
    for i in range(starting/10,amount,pattern):
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
Gets a full list of numbers, with a different amount of digits.
Args:
    starting_digit(int): the amount of digits to use
    pattern(bool): Amount of primes vs composite. True for 1-1, false for else.
    amount_per_digit(int): the amount of numbers per digit spot
Returns:
    num_list(tuple of (int,int))
    the first item is the number itself
    the second number is whether the number is prime or not
    1 for prime, 0 for even
"""
def full_num_list(starting_digit, pattern, amount_per_digit):
    num_list = list()
    for amount in range(starting_digit):
        print "Starting digit count: ",starting_digit - amount,"..."
        starting = get_num_size(starting_digit +1-amount)
        #eliminates small numbers taking up the space of bigger numbers
        min_size = get_num_size(starting_digit - amount)
        tmp_lst = gen_rand_num_list(starting,min_size,amount_per_digit,pattern)
        num_list = num_list + tmp_lst
        print "Finished digit count: ",starting_digit- amount,"..."
    print "Calculated all values!"
    return num_list

"""
Generators a list of primes numbers randomly
Args:
    size(int): the maximum size of the number
    min_size(int): the minimum size of the number
    amount(int): the amount of values to search for
    split(bool): true for a 50-50 split, false otherwise
Returns:
    num_list(tuple of (int,int))
    the first item is the number itself
    the second number is whether the number is prime or not
    1 for prime, 0 for even
"""
def gen_rand_num_list(size,min_size, amount, split):
    #creates a list
    num_list = list()
    count = 0
    spot = 0

    #in the situation that the amount asked for is greater than the range.
    if(amount >= size):
        return single_gen_num_list(size,1)
    while(count < amount):
        number = rand.randint(min_size,size)
        #primes
        if is_prime(number):
        #if(number in Primes()):
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

    return num_list

"""
Creates a number with the amount specified
Args:
    amount(int): the amount of digits to use in the number
Returns:
    num(int): the integer being created
"""
def get_num_size(amount):
    num = 1
    for i in range(amount-1):
        num *= 10
    return num

"""
Finds the amount of numbers to be made
Args:
    digits(int): the maximum amount of digits to be used
    amount(int): amount of numbers being asked per grouping
Returns:
    total(int): the amount of numbers to be put into the file.
"""
def find_number_count(digits, amount):
    #starts as 1 because 1 needs to be included
    total = 0
    for i in range(-1,digits):
        max_size = get_num_size(digits-i)
        min_size = get_num_size(digits-1-i)
        #finds amount of numbers with a spefific digit set
        total_size = max_size-min_size
        #if the amount is greater than the total size
        if(total_size <= amount):
            total += total_size
        else:
            total += amount
    return total

"""
Writes the numbers to a csv file
Args:
    num_list(a list of tuples): In the form (int,int)
        The first int is the number that was checked for primality
        The second int is 1 if prime, 0 otherwise.
    file_name(string): name of the file to output to
"""
def write_to_file(num_list, file_name):
    print "Beginning writing to file..."
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
    print "Ending writing to file..."
    
"""
Does a complete run, with a write to the file.
Args:
    digits(int): the amount of digits to go up to
    split(bool): true for a 50-50 split, false otherwise
    amount_per_digit(int): the amount of values to represent each data area.
    file_name(string): the file to write the information to.
"""
def run(digits, split, amount_per_digit, file_name):
    print "Total amount of numbers: ",find_number_count(digits,amount_per_digit)
    num_list = full_num_list(digits,split,amount_per_digit)
    write_to_file(num_list,file_name)

run(45,True,10000,"numbers.csv")