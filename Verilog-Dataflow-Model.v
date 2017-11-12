//Title of the mini project: Basic Encryption Decryption Model using Asymmetric Key Dataflow Model
//Name : Shushant Kumar, Anmol Horo
//Reg. No.: 16CO143, 16CO206
//Abstract: This model demonstrates the basic working of encryption of data using various keys and methods and then finally decrypting the encrypted data back to get back the original data
//Functionalities: 1. Initially we take a hexadecimal input and convert it into binary format using 16:4 encoder
//                 2. Then this input is negated by passing through not gates 
//                 3. This input is passed through binary to grey converter  
//                 4. This input is further passed to a private key generator which generates a private key using inputs
//                 5. The previous input is XOR with private key , this is first level of encryption
//                 6. Then this input is XOR with public key, second level of encryption
//                 7. Final encrypted input is now generated and further passed to decryption model with private key
//                 8. On decryption side the input is XOR with public key
//                 9. Then this input is XOR with private key
//                10. The previous output generated is passed to grey to binary converter
//                11. Then this is negated by passing through not gates
//                12. This data is passed through 4:16 decoder to get back the final hexadecimal decoded value 
//Brief descriptions on code: Module VerilogDM_143_206 is main module, encryption module is the complete encryption block, encoder module for 16:4 encoder, register module is a 4bit register, binary_to_grey module converts binary input to grey, privatekey module generates private key, decoder module for 4:16 Decoder, grey_to_bin module converts grey to binary, decryption module is the complete decryption block



/* Main Module of the project which takes hexadecimal input and first encrypt it and then decrypt it and output hexadecimal data */
module VerilogDM_143_206 (hexadecimal_input,public_key,hexadecimal_output, private_key,encrypt_data,clk);
input [15:0] hexadecimal_input;                                                         // hexadecimal input
input [3:0] public_key;                                                                 // public key
output [15:0] hexadecimal_output;                                                       // hexadecimal output
output [3:0] private_key;                                                               // private key
output [3:0] encrypt_data;                                                              // encrypted data
input clk;                                                                              // clock
encryption encode(hexadecimal_input, public_key, encrypt_data, private_key,clk);        // Encryption
decryption decode(encrypt_data,private_key, public_key, hexadecimal_output);            // Decryption

endmodule



/* Complete Encryption module */
module encryption (hexadecimal_input, public_key,  final_encoded, private_key,clk);

  input [15:0] hexadecimal_input;         // hexadecimal input
  input [3:0] public_key;                 // public key
  output [3:0] final_encoded;             // encrypted data
  output [3:0] private_key;               // private key
  input clk;                              // Clock

  wire [0:3] encoder_out;
  wire [3:0] binary_to_grey_out;
  wire [3:0] toconv;
  wire [3:0] privatekey_out,p;

  encoder e1(hexadecimal_input,encoder_out);     // converts hexadecimal to binary  

  assign toconv[3] = ~encoder_out[3];            // ngation operation
  assign toconv[2] = ~encoder_out[2];
  assign toconv[1] = ~encoder_out[1];
  assign toconv[0] = ~encoder_out[0];

  binary_to_grey b1(toconv,binary_to_grey_out);           // converts binary to grey code

  privatekey p1(binary_to_grey_out,p);                // generates private key

  register rr1(p,clk,private_key);

  assign privatekey_out[3] = private_key[3]^binary_to_grey_out[3];    // XOR operation with private key
  assign privatekey_out[2] = private_key[2]^binary_to_grey_out[2];
  assign privatekey_out[1] = private_key[1]^binary_to_grey_out[1];
  assign privatekey_out[0] = private_key[0]^binary_to_grey_out[0];

  assign final_encoded[3] = privatekey_out[3]^public_key[3];     // XOR operation with public key
  assign final_encoded[2] = privatekey_out[2]^public_key[2];
  assign final_encoded[1] = privatekey_out[1]^public_key[1];
  assign final_encoded[0] = privatekey_out[0]^public_key[0];

endmodule



/* 16:4 encoder takes hexadecimal input then converts to binary */
module encoder(hexadecimal_input, bin_out);      
    input [15:0] hexadecimal_input;                 // hexadecimal input
    output [3:0] bin_out;                           // binary output

    assign bin_out[0]=(hexadecimal_input[1]|hexadecimal_input[3]|hexadecimal_input[5]|hexadecimal_input[7]|hexadecimal_input[9]|hexadecimal_input[11]|hexadecimal_input[13]|hexadecimal_input[15]);
    assign bin_out[1]=(hexadecimal_input[2]|hexadecimal_input[3]|hexadecimal_input[6]|hexadecimal_input[7]|hexadecimal_input[10]|hexadecimal_input[11]|hexadecimal_input[14]|hexadecimal_input[15]);
    assign bin_out[2]=(hexadecimal_input[4]|hexadecimal_input[5]|hexadecimal_input[6]|hexadecimal_input[7]|hexadecimal_input[12]|hexadecimal_input[13]|hexadecimal_input[14]|hexadecimal_input[15]);
    assign bin_out[3]=(hexadecimal_input[8]|hexadecimal_input[9]|hexadecimal_input[10]|hexadecimal_input[11]|hexadecimal_input[12]|hexadecimal_input[13]|hexadecimal_input[14]|hexadecimal_input[15]);

endmodule



/* 4bit register module */
module register(in_data,clk,out_data);
  input [3:0] in_data;                          // 4bit register input
  input clk;                                    // Clock
  output reg [3:0] out_data;                    // 4bit register output
  
  always @ ( in_data )
  out_data<=in_data;                            // At positive edge of clock output is equal to input
  
endmodule



/* converts 4 bit binary to grey code */
module binary_to_grey(bin_inp, grey_out);            

  input [3:0] bin_inp;                            // binary input
  output [3:0] grey_out;                          // grey code output

  assign grey_out[3] = bin_inp[3];
  assign grey_out[2] = bin_inp[3]^bin_inp[2];
  assign grey_out[1] = bin_inp[1]^bin_inp[2];
  assign grey_out[0] = bin_inp[1]^bin_inp[0];

endmodule



/* function to generate private key from input data */
module privatekey(                                  
input [3:0] pre_in,                                 // binary input
output [3:0] private_key                            // private key
);


   assign private_key[3]= pre_in[3] & pre_in[2] & pre_in[1] & pre_in[0];                // for input a,b,c,d it returns a.b.c.d

   assign private_key[2]= (pre_in[3] & pre_in[2] & pre_in[1] ) | (pre_in[2] & pre_in[1] & pre_in[0] ) | (pre_in[3] & pre_in[1] & pre_in[0]) | ( pre_in[2] & pre_in[3] & pre_in[0] );                                 // for input a,b,c,d it returns abc+acd+bcd+abd

   assign private_key[1]= (pre_in[3] & pre_in[2]) | (pre_in[1] & pre_in[0]) | (pre_in[3] & pre_in[1]) | (pre_in[3] & pre_in[0]) | (pre_in[2] & pre_in[1]) | (pre_in[2] & pre_in[0]) ;                               // for input a,b,c,d it returns ab+bc+cd+da+ac+bd

   assign private_key[0]= pre_in[3] | pre_in[2] | pre_in[1] | pre_in[0];                // for input a,b,c,d it returns a+b+c+d
   
endmodule



/* 4:16 Decoder module */
module decoder(                                    
  input [3:0] binary,                               // binary input
  output [15:0] hexadeci                            // hexadecimal output
 );

  assign hexadeci[0]=(~binary[3]&~binary[2]&~binary[1]&~binary[0]);
  assign hexadeci[1]=(~binary[3]&~binary[2]&~binary[1]&binary[0]);
  assign hexadeci[2]=(~binary[3]&~binary[2]&binary[1]&~binary[0]);
  assign hexadeci[3]=(~binary[3]&~binary[2]&binary[1]&binary[0]);
  assign hexadeci[4]=(~binary[3]&binary[2]&~binary[1]&~binary[0]);
  assign hexadeci[5]=(~binary[3]&binary[2]&~binary[1]&binary[0]);
  assign hexadeci[6]=(~binary[3]&binary[2]&binary[1]&~binary[0]);
  assign hexadeci[7]=(~binary[3]&binary[2]&binary[1]&binary[0]);
  assign hexadeci[8]=(binary[3]&~binary[2]&~binary[1]&~binary[0]);
  assign hexadeci[9]=(binary[3]&~binary[2]&~binary[1]&binary[0]);
  assign hexadeci[10]=(binary[3]&~binary[2]&binary[1]&~binary[0]);
  assign hexadeci[11]=(binary[3]&~binary[2]&binary[1]&binary[0]);
  assign hexadeci[12]=(binary[3]&binary[2]&~binary[1]&~binary[0]);
  assign hexadeci[13]=(binary[3]&binary[2]&~binary[1]&binary[0]);
  assign hexadeci[14]=(binary[3]&binary[2]&binary[1]&~binary[0]);
  assign hexadeci[15]=(binary[3]&binary[2]&binary[1]&binary[0]);

endmodule
  
  

 /* converts 4 bit grey code to binary */
module grey_to_binary(grey_code,binary_data);   
    input [3:0] grey_code;                        // grey code input
    output [3:0] binary_data;                       // binary output
  
    assign binary_data[3]=grey_code[3];
    assign binary_data[2]=binary_data[3]^grey_code[2];
    assign binary_data[1]=binary_data[2]^grey_code[1];
    assign binary_data[0]=binary_data[1]^grey_code[0];
  
endmodule



/* Complete Decryption model  */
module decryption(endata,prvi_key,publ_key,hexadecimal_output);

  input [3:0] endata;                                    // encrypted data
  input [3:0] prvi_key;                                  // private key
  input [3:0] publ_key;                                  // public key
  output [15:0] hexadecimal_output;                      // hexadecimal output
  
  wire [3:0] xor_public;                                 // stores data after XOR with the public key
  wire [3:0] xor_private;                                // stores data after XOR with the private key
  wire [3:0] converted_binary;                           // stores data which is to be converted back to binary
  wire [3:0] negate;                                     // stores data after negation
  
  assign xor_public[3]=endata[3] ^ publ_key[3];          // XOR operation of encrypted data and public key
  assign xor_public[2]=endata[2] ^ publ_key[2];
  assign xor_public[1]=endata[1] ^ publ_key[1];
  assign xor_public[0]=endata[0] ^ publ_key[0];
  
 
  assign xor_private[3]=xor_public[3] ^ prvi_key[3];      // XOR operation with private key
  assign xor_private[2]=xor_public[2] ^ prvi_key[2];
  assign xor_private[1]=xor_public[1] ^ prvi_key[1];
  assign xor_private[0]=xor_public[0] ^ prvi_key[0];
  
  grey_to_binary gg(xor_private,converted_binary);        // converts greycode to binary
  
  assign negate[3]= ~converted_binary[0] ;                // negation operation
  assign negate[2]= ~converted_binary[1] ;
  assign negate[1]= ~converted_binary[2] ;
  assign negate[0]= ~converted_binary[3] ;
  
  decoder dr(negate,hexadecimal_output);                 // 4:16 decoder
   
endmodule
  
