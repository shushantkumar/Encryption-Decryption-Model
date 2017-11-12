Title of the mini project: Basic Encryption Decryption Model using Asymmetric Key <br>
Name : Shushant Kumar, Anmol Horo<br>
Reg. No.: 16CO143, 16CO206<br>
Abstract: This model demonstrates the basic working of encryption of data using various keys and methods and then finally decrypting the encrypted data back to get back the original data<br><br>
Functionalities: 1. Initially we take a hexadecimal input and convert it into binary format using 16:4 encoder<br>
                 2. Then this input is negated by passing through not gates <br>
                 3. This input is passed through binary to grey converter  <br>
                 4. This input is further passed to a private key generator which generates a private key using inputs<br>
                 5. The previous input is XOR with private key , this is first level of encryption<br>
                 6. Then this input is XOR with public key, second level of encryption<br>
                 7. Final encrypted input is now generated and further passed to decryption model with private key<br>
                 8. On decryption side the input is XOR with public key<br>
                 9. Then this input is XOR with private key<br>
                10. The previous output generated is passed to grey to binary converter<br>
                11. Then this is negated by passing through not gates<br>
                12. This data is passed through 4:16 decoder to get back the final hexadecimal decoded value <br>

<br>
Detailed explanation of each module and steps in them<br>

:- The main module is VerilogDM_143_206(for Dataflow) or VerilogBM_143_206(for behavioral) which takes Hexadecimal Input and calls module encryption which returns the encrypted data and then send this data to another module decryption which returns the Hexadecimal data. This value is final output.<br>
:- The next module is encryption module. This first receives hexadecimal input. It calls module encoder which returns back the binary value. Then it negates this inputs. Then this is sent to binary_to_grey module which returns grey code for the input binary input. Then this is passed to privatekey module which generates the private key and returns it back. They grey code output and then private key are XOR. This is followed by XOR with public key. This is sent as output.<br>
:- The next module is encoder module which is 16:4 encoder block which takes hexadecimal input and returns output as binary of that number.<br>
:- The next module is register module which is a 4bit register.<br>
:- The next module is binary_to_grey module which converts binary input to its equivalent grey code.<br>
:- The next module is privatekey module which generates a key. It takes 4bit input consider A,B,C,D and it returns 4bits that are A.B.C.D , A.B.C + B.C.D + C.D.A + A.B.D , A.B + B.C + C.D + A.D + A.C + B.D , A + B + C + D<br>
:- The next module is decoder module which is 4:16 decoder block, which takes binary input and returns hexadecimal output.<br>
:- The next module is grey_to_binary module which converts grey code input to its equivalent binary code. <br>
:- The next module is decryption module. This takes input as 4bit input from encryption block, 4bit private key, 4bit public key. It first XOR the 4bit input from encryption block with public key. Then this is XOR with private key. Then it calls grey_to_binary module which returns its binary output. Then all the bits are negated. Then this data is passed to decoder module which takes in binary input and returns the hexadecimal equivalent of it. This is the final output.   <br>