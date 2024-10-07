#################################solution 1########################################
print("solution 1\n")

import math
from string import ascii_lowercase
ALPHABET=ascii_lowercase
ALPHABET_SIZE=26

LETTER_FREQUENCY = {'e':12.7, 't':9.06, 'a':8.17, 'o':7.51, 'i':6.97, 'n':6.75, 's':6.33, 'h':6.09, 'r':5.99, 'd':4.25, 'l':4.03, 'c':2.78, 'u':2.76, 'm':2.41, 'w':2.36, 'f':2.23, 'g':2.02, 'y':1.97, 'p':1.93, 'b':1.29, 'v':0.98, 'k':0.77, 'j':0.15, 'x':0.15, 'q':0.10, 'z':0.07 }
def decrypt(cipher_text: str, key: int) -> str:
    output= ''
    for char in cipher_text:
        if not char.isalpha():
            output += char
            continue
        index = ALPHABET.index(char.lower())
        new_char = ALPHABET[(index- key) % ALPHABET_SIZE]
        output += new_char.upper() if char.isupper() else new_char
    return output

#def difference(text: str)-> float:
#    counter = Counter(text)
#    return sum([abs(counter.get(letter, 0)*100/len(text)-LETTER_FREQUENCY[letter]) for letter in ALPHABET]) / ALPHABET_SIZE


def break_cipher(cipher_text: str, size:int=26): #->int:
    #lowest_difference = math.inf
    #encryption_key = 0
    for key in range(1,size):
        current_plain_text = decrypt(cipher_text,key)
        #current_difference = difference(current_plain_text)
        print(f"Key={key} - PlainText={current_plain_text}")

       # if current_difference < lowest_difference:
       #     lowest_difference = current_difference
       #     encryption_key = key
    #return encryption_key

break_cipher(cipher_text="VSRQJHEREVTXDUHSDQWV")

print("\n=======================================================================================")

#################################solution 2########################################
print("solution 2")

LETTER_FREQUENCY = {'e':12.7, 't':9.06, 'a':8.17, 'o':7.51, 'i':6.97, 'n':6.75, 's':6.33, 'h':6.09, 'r':5.99, 'd':4.25, 'l':4.03, 'c':2.78, 'u':2.76, 'm':2.41, 'w':2.36, 'f':2.23, 'g':2.02, 'y':1.97, 'p':1.93, 'b':1.29, 'v':0.98, 'k':0.77, 'j':0.15, 'x':0.15, 'q':0.10, 'z':0.07 }
message="GBSXUCGSZQGKGSQPKQKGLSKASPCGBGBKGUKGCEUKUZKGGBSQEICACGKGCEUERWKLKUPKQQGCIICUAEUVSHqKGCEUPCGBCGQOEVSHUNSUGKUZCGQSNLSHEHIEEDCUOGEPKHZGBSNKCUGSUKUASERLSKASCUGBSLKACRCACUZSSZEUSBEXHKRGSHWKLKUSQSKCHQTXKZHEUQBKZAENNSUASZFENFCUOCUEKBXGBSWKLKUSQSKNFKQQKZEHGEGBSXUCGSZQGKGSQKUZBCQAEIISKOXSZSICVSHSZGEGBSQSAHSGKHMERQGKGSKREHNKIHSLIMGEKHSASUGKNSHCAKUNSQQKOSPBCISGBCqHSLIMQGKGSZGBKGCGQSSNSZXQSISQQGEAEUGCUXSGBSSJCqGCUOZCLIENKGCAUSOEGCKGCEUqCGAEUGKCUSZUEGBHSKGEHBCUGERPKHEHKHNSZKGGKAD"
message2=message.upper()
stored_letters={}
for char in message2:
    if char not in stored_letters:
        stored_letters[char]=1
    else:
        stored_letters[char] +=1

stored_letters = sorted(stored_letters.items(), key=lambda x: x[1], reverse=True)
LETTER_FREQUENCY = sorted(LETTER_FREQUENCY.items(), key=lambda x: x[1], reverse=True)

print("\nstored letters:")
print(stored_letters)
print("\nletter frequency:")
print(LETTER_FREQUENCY)

messageCopy=message
length=len(messageCopy)

length = len(stored_letters)
for i in range(length):
    messageCopy=messageCopy.replace(stored_letters[i][0],LETTER_FREQUENCY[i][0])

print("\nplaintext:")
print(messageCopy)
