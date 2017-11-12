  //Title of the mini project: Basic Encryption Decryption Model using Asymmetric Key Behavioral Model
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
  //Brief descriptions on code: Module VerilogBM_143_206 is main module, encryption module is the complete encryption block, encoder module for 16:4 encoder, register module is a 4bit register, bintogrey module converts binary input to grey, privatekey module generates private key, decoder module for 4:16 Decoder, grey_to_bin module converts grey to binary, decryption module is the complete decryption block



  /* Main Module of the project which takes hexadecimal input and first encrypt it and then decrypt it and output hexadecimal data */ 
  module VerilogBM_143_206 (
  input [15:0] hexadecimal_input,                 // hexadecimal input
  input [3:0] public_key,                         // public key
  output reg [15:0] hexadecimal_output,           // hexadecimal output
  output reg [3:0] private_key,                   // private key
  output reg [3:0] encrypt_data,                  // encrypted data
  input clk                                       // clock signal
  );

  reg [15:0] hex_in;								//hexadecimal input copy
  reg [3:0] publ_key;								//public key copy
  wire [3:0] encrypt_out;						//Encrypted data copy
  wire [3:0] prv_key;								//Private key copy
  reg [3:0] endata;								  //Encrypted data 
  reg [3:0] prvi_key;								//Private key
  wire [15:0] hex_out;							//hexadecimal output

    encryption encode(                           // Encryption
  	.hex_in(hex_in),
  	.publ_key(publ_key),
  	.encrypt_out(encrypt_out),
  	.prv_key(prv_key),
  	.clk(clk));

    decryption decode(                           // Decryption
  	.endata(endata),
  	.prvi_key(prvi_key),
  	.publ_key(publ_key),
  	.hex_out(hex_out));
    
  always @ (*)
  begin
  hex_in<=hexadecimal_input;                   // passing hexadecimal input to encryption encode instance
  publ_key<=public_key;    					           // assigning public key                   
  endata<=encrypt_out;						             // assigning encrypted data
  prvi_key<=prv_key;							             // assigning hexadecimal output
  hexadecimal_output<=hex_out;				         // assigning hexadecimal output to final output variable
  encrypt_data<=endata;						             // assigning encrypted data to final output variable
  private_key<=prv_key;						             // assigning private key to final output variable
  end
  endmodule



  /* Complete Encryption module */
  module encryption (
  input [15:0] hex_in,                       // hexadecimal input
  input [3:0] publ_key,                      // public key
  output reg [3:0] encrypt_out,              // encrypted data
  output reg [3:0] prv_key,                  // private key
  input clk                                  // clock signal
  );

    wire [0:3] bin_out;                         // binary output
    reg [3:0] bin_inp;                          // binay input
    wire [3:0] grey_out;                        // grey code output
    reg [3:0] pre_in;                           // using this private key is generated
    reg [3:0] toconv;                           // data to be converted to grey code
    reg [3:0] privatekey_out;                   // stores data after xor with private key 
    wire [3:0] private_key;                     // stores private key
    reg [3:0] in_data;                          // stores input of register instance
    wire [3:0] out_data;                        // stores output of register instance
    encoder e1(                                 // 16:4 encoder block
    	.hex_in(hex_in),
    	.bin_out(bin_out));

    bintogrey b1(                            // binary to grey code
    	.bin_inp(bin_inp),
    	.grey_out(grey_out));

    privatekey p1(                           // private key generating function
    	.pre_in(pre_in),
    	.private_key(private_key));

    register r1(                             // register 
    .in_data(in_data),
     .clk(clk),
     .out_data(out_data));

    always @ (*)
    begin
      toconv[3] <= ~bin_out[3];                // negation operation
      toconv[2] <= ~bin_out[2];
      toconv[1] <= ~bin_out[1];
      toconv[0] <= ~bin_out[0];

      bin_inp <= toconv;                      // giving Input to instance b1
      pre_in <= grey_out;                     // taking output from instance b1 and giving it as input to instance p1 
      in_data<=private_key;                   // Taking output from instance p1

      privatekey_out[3] <= private_key[3]^grey_out[3];              // XOR operation with private key
      privatekey_out[2] <= private_key[2]^grey_out[2];
      privatekey_out[1] <= private_key[1]^grey_out[1];
      privatekey_out[0] <= private_key[0]^grey_out[0];

      encrypt_out[3] <= privatekey_out[3]^publ_key[3];              // XOR operation with public key
      encrypt_out[2] <= privatekey_out[2]^publ_key[2];
      encrypt_out[1] <= privatekey_out[1]^publ_key[1];
      encrypt_out[0] <= privatekey_out[0]^publ_key[0];

      prv_key[3] <= out_data[3];                                //Reversing the binary number
      prv_key[2] <= out_data[2];
      prv_key[1] <= out_data[1];
      prv_key[0] <= out_data[0];

    end
  endmodule



  /* 16:4 encoder takes hexadecimal input then converts to binary */
  module encoder(                                  
  input [15:0] hex_in,                            // hexadecimal input
  output reg [3:0] bin_out                        // binary output
  );
    always @ (*)
    begin
    	    bin_out[0]<=(hex_in[1]|hex_in[3]|hex_in[5]|hex_in[7]|hex_in[9]|hex_in[11]|hex_in[13]|hex_in[15]);
    	    bin_out[1]<=(hex_in[2]|hex_in[3]|hex_in[6]|hex_in[7]|hex_in[10]|hex_in[11]|hex_in[14]|hex_in[15]);
    	    bin_out[2]<=(hex_in[4]|hex_in[5]|hex_in[6]|hex_in[7]|hex_in[12]|hex_in[13]|hex_in[14]|hex_in[15]);
    	    bin_out[3]<=(hex_in[8]|hex_in[9]|hex_in[10]|hex_in[11]|hex_in[12]|hex_in[13]|hex_in[14]|hex_in[15]);
    end
  endmodule



  /* Register module */
  module register(in_data,clk,out_data);
    input [3:0] in_data;                          // input data
    input clk;                                    // clock signal
    output reg [3:0] out_data;                    // output data

    always @ (in_data)                      // works at the positive edge of the clock cycle
    out_data<=in_data;
    
   endmodule

   

  /* module converts 4 bit grey code to binary */
  module bintogrey(                                  
  input [3:0] bin_inp,                               // binary input
  output reg [3:0] grey_out                          // grey code
  );     

    always @(*)
    begin                                            //Operations to convert binary to grey code
      grey_out[3] <= bin_inp[3];
      grey_out[2] <= bin_inp[3]^bin_inp[2];
      grey_out[1] <= bin_inp[1]^bin_inp[2];
      grey_out[0] <= bin_inp[1]^bin_inp[0];
    end
  endmodule



  /* module to generate private key from input data using some functions */
  module privatekey(                                  
  input [3:0] pre_in,                                 // binary input
  output reg [3:0] private_key                        // private key
  );   

    always @ (*)
    begin
         private_key[3]<= pre_in[3] & pre_in[2] & pre_in[1] & pre_in[0];       // for input a,b,c,d it returns a.b.c.d
    	 
         private_key[2]<= (pre_in[3] & pre_in[2] & pre_in[1] ) | (pre_in[2] & pre_in[1] & pre_in[0] ) | (pre_in[3] & pre_in[1] & pre_in[0]) | ( pre_in[2] & pre_in[3] & pre_in[0] );                                 //for input a,b,c,d it returns abc+acd+bcd+abd
    	 
         private_key[1]<= (pre_in[3] & pre_in[2]) | (pre_in[1] & pre_in[0]) | (pre_in[3] & pre_in[1]) | (pre_in[3] & pre_in[0]) | (pre_in[2] & pre_in[1]) | (pre_in[2] & pre_in[0]) ;                               // for input a,b,c,d it returns ab+bc+cd+da+ac+bd
    	 
         private_key[0]<= pre_in[3] | pre_in[2] | pre_in[1] | pre_in[0];      // for input a,b,c,d it returns a+b+c+d
    end
  endmodule



  /* 4:16 decoder module */
  module decoder(                                     
    input [3:0] binary,                               // binary input
    output reg [15:0] hex_deci                        // hexadecimal input
   );
    always @(*)
    begin                                              
      hex_deci[0]<=(~binary[3]&~binary[2]&~binary[1]&~binary[0]);
      hex_deci[1]<=(~binary[3]&~binary[2]&~binary[1]&binary[0]);
      hex_deci[2]<=(~binary[3]&~binary[2]&binary[1]&~binary[0]);
      hex_deci[3]<=(~binary[3]&~binary[2]&binary[1]&binary[0]);
      hex_deci[4]<=(~binary[3]&binary[2]&~binary[1]&~binary[0]);
      hex_deci[5]<=(~binary[3]&binary[2]&~binary[1]&binary[0]);
      hex_deci[6]<=(~binary[3]&binary[2]&binary[1]&~binary[0]);
      hex_deci[7]<=(~binary[3]&binary[2]&binary[1]&binary[0]);
      hex_deci[8]<=(binary[3]&~binary[2]&~binary[1]&~binary[0]);
      hex_deci[9]<=(binary[3]&~binary[2]&~binary[1]&binary[0]);
      hex_deci[10]<=(binary[3]&~binary[2]&binary[1]&~binary[0]);
      hex_deci[11]<=(binary[3]&~binary[2]&binary[1]&binary[0]);
      hex_deci[12]<=(binary[3]&binary[2]&~binary[1]&~binary[0]);
      hex_deci[13]<=(binary[3]&binary[2]&~binary[1]&binary[0]);
      hex_deci[14]<=(binary[3]&binary[2]&binary[1]&~binary[0]);
      hex_deci[15]<=(binary[3]&binary[2]&binary[1]&binary[0]);
    end
  endmodule
    
    
    
  /* module to convert 4 bit grey code to binary */
  module grey_to_binary(grey_code,binary_data);        
      input [3:0] grey_code;                             // grey code input
  	  output reg [3:0] binary_data;                      // binary output
  	  always @(*)
  	  begin                                             // operations to convert grey code to binary
  	   binary_data[3]<=grey_code[3];
  	   binary_data[2]<=binary_data[3]^grey_code[2];
  	   binary_data[1]<=binary_data[2]^grey_code[1];
  	   binary_data[0]<=binary_data[1]^grey_code[0];
  	  end
  endmodule



  /* Complete Decryption module */
  module decryption(endata,prvi_key,publ_key,hex_out);
    input [3:0] endata;                                  // encrypted data
    input [3:0] prvi_key;                                // private key
    input [3:0] publ_key;                                // public key
    output reg [15:0] hex_out;                           // hexadecimal output
    
    reg [3:0] xor_public;                                // stores data after xor  with public key 
    reg [3:0] xor_private;                               // stores data after xor with private key
    reg [3:0] converted_binary;                          // stores data which has to be converted back to binary
    reg [3:0] negate;                                    // stores data after negation
    reg [3:0] grey_code;                                 // stores grey code
    reg [3:0] binary;                                    // stores data after grey code is convered to binary
    wire [15:0] hex_deci;                                // stores temporary hexadecimal 
    wire [3:0] binary_data;                              // stores temporary binary data
    
    grey_to_binary gg(                                   // converts grey code to binary
  	.grey_code(grey_code),                             
  	.binary_data(binary_data));

    decoder dr(                                         // 4:16 decoder
  	.binary(binary),
  	.hex_deci(hex_deci));
    
    
    always @(*)
    begin
      xor_public[3]<=endata[3] ^ publ_key[3];           // XOR operation of encrypted data and public key
      xor_public[2]<=endata[2] ^ publ_key[2];           
      xor_public[1]<=endata[1] ^ publ_key[1];
      xor_public[0]<=endata[0] ^ publ_key[0];
    
   
      xor_private[3]<=xor_public[3] ^ prvi_key[3];     // XOR operation of data and private key
      xor_private[2]<=xor_public[2] ^ prvi_key[2];
      xor_private[1]<=xor_public[1] ^ prvi_key[1];
      xor_private[0]<=xor_public[0] ^ prvi_key[0];
    
       grey_code<=xor_private;                        // giving grey code data to instance gg                
  	 converted_binary<=binary_data;                   // taking binary ouput from instance gg
      

    
      negate[3]<= ~converted_binary[0] ;             // negation operation
      negate[2]<= ~converted_binary[1] ;
      negate[1]<= ~converted_binary[2] ;
      negate[0]<= ~converted_binary[3] ;
      
  	binary<=negate;                               // giving binary input to instance dr
  	hex_out<=hex_deci;                            // hexadecimal output
  	 
    
    end
    endmodule
    
    