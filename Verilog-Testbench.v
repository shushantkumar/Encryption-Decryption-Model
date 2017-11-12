//Title of the mini project: Basic Encryption Decryption Model using Asymmetric Key Testbench
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
 


`timescale 1ns/100ps

module Verilog_143_206;
reg [15:0] hex_in;               // hexadecimal input
reg [3:0] public_key;            // public key
wire [15:0] hex_out;             // hexadecimal output
wire [3:0] private_keyrec;       // Private key
wire [3:0] encrypt_data;         // Encrypted data
reg clk;


/*VerilogDM_143_206 inst(hex_in,public_key,hex_out,private_keyrec,encrypt_data,clk);*/ // Uncomment this line and comment next line for running Dataflow module 


VerilogBM_143_206 inst(hex_in,public_key,hex_out,private_keyrec,encrypt_data,clk);


    initial
    begin

        /*$dumpfile("VerilogDM-143-206.vcd");*/ // Uncomment this line and comment next line for Dataflow module

        $dumpfile("VerilogBM-143-206.vcd");

        $dumpvars(0,Verilog_143_206);

         // display
        $monitor("Hexadecimal input = %b\tprivate key= %b\tpublic key =%b\tencrypted data= %b\thexadecimal output= %b",hex_in,private_keyrec,public_key,encrypt_data,hex_out);


        //Giving all possible inputs with different public keys
        
        #10 hex_in=16'b0000000000000001;            //Giving input 0
            public_key = 4'b1111;
        #10 hex_in=16'b0000000000000010;            //Giving input 1
            public_key = 4'b1101;
        #10 hex_in=16'b0000000000000100;            //Giving input 2
            public_key = 4'b0111;
        #10 hex_in=16'b0000000000001000;            //Giving input 3
            public_key = 4'b1000;
        #10 hex_in=16'b0000000000010000;            //Giving input 4
            public_key = 4'b1001;
        #10 hex_in=16'b0000000000100000;            //Giving input 5
            public_key = 4'b0011;
        #10 hex_in=16'b0000000001000000;            //Giving input 6
            public_key = 4'b1010;
        #10 hex_in=16'b0000000010000000;            //Giving input 7
            public_key = 4'b0101;
        #10 hex_in=16'b0000000100000000;            //Giving input 8
            public_key = 4'b0001;
        #10 hex_in=16'b0000001000000000;            //Giving input 9
            public_key = 4'b0110;
        #10 hex_in=16'b0000010000000000;            //Giving input A
            public_key = 4'b0010;
        #10 hex_in=16'b0000100000000000;            //Giving input B
            public_key = 4'b0100;
        #10 hex_in=16'b0001000000000000;            //Giving input C
            public_key = 4'b0000;
        #10 hex_in=16'b0010000000000000;            //Giving input D
            public_key = 4'b1110;
        #10 hex_in=16'b0100000000000000;            //Giving input E
            public_key = 4'b1101;
        #10 hex_in=16'b1000000000000000;            //Giving input F
            public_key = 4'b1011;

    end

    initial begin
        clk=1'b0;       
        repeat(34)              // loop to toggle clock signal
        # 5 clk=~clk;
    end

        initial #160 $finish();

endmodule



