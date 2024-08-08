#!/usr/bin/env python3
import os
import base64
import M2Crypto.EVP


class SymmetricEncryption(object):

    @staticmethod
    def generate_key():
        return base64.b64encode(os.urandom(48))

    def __init__(self, key):
        key = base64.b64decode(key)
        self.iv = key[:16]
        self.key = key[16:]

    def encrypt(self, plaintext):
        ENCRYPT = 1
        cipher = M2Crypto.EVP.Cipher(alg='aes_256_cbc', key=self.key, iv=self.iv, op=ENCRYPT)
        ciphertext = cipher.update(plaintext) + cipher.final()
        return base64.b64encode(ciphertext)

    def decrypt(self, cyphertext):
        DECRYPT = 0
        cipher = M2Crypto.EVP.Cipher(alg='aes_256_cbc', key=self.key, iv=self.iv, op=DECRYPT)
        plaintext = cipher.update(base64.b64decode(cyphertext)) + cipher.final()
        return plaintext



test_instance = SymmetricEncryption( SymmetricEncryption.generate_key() )
test_phrase = base64.b64encode("Iamamightytest".encode())
encrypted_phrase = test_instance.encrypt( test_phrase )
decrypted_phrase = test_instance.decrypt( encrypted_phrase )

if decrypted_phrase == test_phrase:
      print( "Test passed" )
else:
      print( "Test failed" )
