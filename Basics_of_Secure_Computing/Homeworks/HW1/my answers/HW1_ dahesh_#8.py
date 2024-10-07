#!/usr/bin/env python
# coding: utf-8

# In[2]:


# !pip install pycryptodome


# In[1]:


import cv2
import numpy as np
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from Crypto.Random import get_random_bytes
from numpy import zeros, newaxis


# In[8]:


image = cv2.imread(r'C:\Users\hoori\Desktop\HW1\HW1_ dahesh_#8.jpg')

gray= cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

cv2.imshow('Grayscale', gray)
cv2.imwrite(r'C:\Users\hoori\Desktop\HW1\HW1_ dahesh_#8_gray.jpg',gray )
cv2.waitKey(0)  
  
# Window shown waits for any key pressing event
cv2.destroyAllWindows()


# In[9]:


mode = AES.MODE_ECB

# Set sizes
keySize = 32
ivSize = AES.block_size if mode == AES.MODE_CBC else 0

# Start Encryption ----------------------------------------------------------------------------------------------

# Load original image
imageOrig = gray
imageOrig = imageOrig[:, :, newaxis]
rowOrig, columnOrig, depthOrig = imageOrig.shape

# Convert original image data to bytes
imageOrigBytes = imageOrig.tobytes()

# Encrypt
key = get_random_bytes(keySize)
iv = get_random_bytes(ivSize)
cipher = AES.new(key, AES.MODE_CBC, iv) if mode == AES.MODE_CBC else AES.new(key, AES.MODE_ECB)
imageOrigBytesPadded = pad(imageOrigBytes, AES.block_size)
ciphertext = cipher.encrypt(imageOrigBytesPadded)

# Convert ciphertext bytes to encrypted image data
#    The additional row contains columnOrig * DepthOrig bytes. Of this, ivSize + paddedSize bytes are used 
#    and void = columnOrig * DepthOrig - ivSize - paddedSize bytes unused
paddedSize = len(imageOrigBytesPadded) - len(imageOrigBytes)
void = columnOrig * depthOrig - ivSize - paddedSize
ivCiphertextVoid = iv + ciphertext + bytes(void)
imageEncrypted = np.frombuffer(ivCiphertextVoid, dtype = imageOrig.dtype).reshape(rowOrig + 1, columnOrig, depthOrig)

# Display encrypted image
cv2.imshow("ECB image", imageEncrypted)
cv2.imwrite(r'C:\Users\hoori\Desktop\HW1\HW1_ dahesh_#8_ECB.jpg', imageEncrypted)
cv2.waitKey()
cv2.destroyAllWindows()


# In[10]:


mode = AES.MODE_CBC

# Set sizes
keySize = 32
ivSize = AES.block_size if mode == AES.MODE_CBC else 0

# Start Encryption ----------------------------------------------------------------------------------------------

# Load original image
imageOrig = gray
imageOrig = imageOrig[:, :, newaxis]
rowOrig, columnOrig, depthOrig = imageOrig.shape

# Convert original image data to bytes
imageOrigBytes = imageOrig.tobytes()

# Encrypt
key = get_random_bytes(keySize)
iv = get_random_bytes(ivSize)
cipher = AES.new(key, AES.MODE_CBC, iv) if mode == AES.MODE_CBC else AES.new(key, AES.MODE_ECB)
imageOrigBytesPadded = pad(imageOrigBytes, AES.block_size)
ciphertext = cipher.encrypt(imageOrigBytesPadded)

# Convert ciphertext bytes to encrypted image data
#    The additional row contains columnOrig * DepthOrig bytes. Of this, ivSize + paddedSize bytes are used 
#    and void = columnOrig * DepthOrig - ivSize - paddedSize bytes unused
paddedSize = len(imageOrigBytesPadded) - len(imageOrigBytes)
void = columnOrig * depthOrig - ivSize - paddedSize
ivCiphertextVoid = iv + ciphertext + bytes(void)
imageEncrypted = np.frombuffer(ivCiphertextVoid, dtype = imageOrig.dtype).reshape(rowOrig + 1, columnOrig, depthOrig)

# Display encrypted image
cv2.imshow("CBC image", imageEncrypted)
cv2.imwrite(r'C:\Users\hoori\Desktop\HW1\HW1_ dahesh_#8_CBC.jpg', imageEncrypted)
cv2.waitKey()
cv2.destroyAllWindows()


# In[ ]:




