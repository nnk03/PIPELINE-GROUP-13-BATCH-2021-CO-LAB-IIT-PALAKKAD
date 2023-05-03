`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2023 18:12:14
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;

    
    
    reg [255:0] instruction;
    reg clk, rst;
    reg [31:0] instruction_cache [7:0];
    // the above is the instruction cache which holds the instruction
    
    
    
    
    wire [31:0] rv1, rv2, imm, ans_from_value,current_instruction;
    wire [3:0] risl_type;
    
    pipeline DUT(instruction, clk, rst, rv1, rv2, imm, ans_from_value,current_instruction,risl_type);
    // the instruction passed to the pipeline module is a single string of 8*32 = 256 bits
    
    
    initial begin
    clk = 1'b0;
    rst = 1'b1;
    instruction_cache[0] = {12'd0,5'd29,3'b000,5'd29,7'b0010011};
    instruction_cache[1] = {12'd1,5'd30,3'b000,5'd30,7'b0010011};
    instruction_cache[2] = {12'd0,5'd29, 3'b010, 5'd28, 7'b0000011};
    instruction_cache[3] = {12'd0,5'd30, 3'b010, 5'd27, 7'b0000011};
    instruction_cache[4] = {7'b0, 5'd29, 5'd28, 3'b0, 5'd10, 7'b0110011};
    instruction_cache[5] = {7'b0,5'd29,5'd10, 3'b010, 5'd0, 7'b0100011};
    instruction_cache[6] = 32'h0;
    instruction_cache[7] = 32'h0;
    instruction = {instruction_cache[7],instruction_cache[6],instruction_cache[5],instruction_cache[4],instruction_cache[3],instruction_cache[2],instruction_cache[1],instruction_cache[0]};

    #20
    rst = 1'b0;
//    $display("instruction from testbench is ", instruction);
     instruction = {instruction[7],instruction[6],instruction[5],instruction[4],instruction[3],instruction[2],instruction[1],instruction[0]};
     
    
    
    
    
    
    #320 $finish;

    end
    
    always #5 clk = ~clk;





endmodule



    
    
    
    
    
//    #20
//    rst = 1'b0;
//    // addi x29, x0, x4;
////    instruction = {12'd4,5'b0,3'b000,5'd29,7'b0010011};
//    //addi x29, x29, 0;
//    instruction = {12'd0,5'd29,3'b000,5'd29,7'b0010011};
    
    
    
    
    
//    #40
//    // add x30, x29, x29;
////    instruction =  {7'b0, 5'd29, 5'd29, 3'b0, 5'd30, 7'b0110011};

//    //addi x30, x30, 1;    
//    instruction = {12'd1,5'd30,3'b000,5'd30,7'b0010011};
    
    
    
    
////    #40
////    instruction = {7'b0, 5'd29, 5'd29, 3'b0, 5'd29, 7'b0110011};
////    #40
////    instruction = {7'b0100000, 5'd29, 5'd29, 3'b0, 5'd29, 7'b0110011};
//    #40
//    // sw x30 1(x21);
////    instruction = {7'b0,5'd21,5'd30, 3'b010, 5'd1, 7'b0100011};


//    // lw x28, 0(x29)
//        instruction = {12'd0,5'd29, 3'b010, 5'd28, 7'b0000011};
    
    
    
    
    
//    #40
//    // sw x30 1(x29);
//    // sw A, constant(B)
//    // instruction is of the form 7'bconstant[11:5] , 5'dB, 5'dA, 5'dconstant[4:0], 7'b0100011
////    instruction = {7'b0,5'd29,5'd30, 3'b010, 5'd1, 7'b0100011};


//    // lw x27, 0(x30);    
    
//    instruction = {12'd0,5'd30, 3'b010, 5'd27, 7'b0000011};
    
    
    
//    #40
//    //lw x29 1(x21);
//    // lw A, constant(B)
//    // instruction is of the form 12'd constant, 5'd B, 3'b010, 5'd A, 7'b0000011
////    instruction = {12'd1,5'd21, 3'b010, 5'd29, 7'b0000011};

//    // add x10, x28, x29    
//    instruction =  {7'b0, 5'd29, 5'd28, 3'b0, 5'd10, 7'b0110011};
    
    
    
//    #40
//    // sw x10 0(x29)
//    instruction = {7'b0,5'd29,5'd10, 3'b010, 5'd0, 7'b0100011};
   
    
    
    
    
    




