`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:07:54
// Design Name: 
// Module Name: alu_with_clk
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


module booth_multiplier(
  input [31:0] A,
  input [31:0] B,
  input clk,
  output reg [63:0] answer
);
  

  
  
  reg [63:0] accumulator;
  reg [63:0] A_complete;
  reg [63:0] A_comp_complete;
  reg flag;
//   initial begin
//     accumulator <= 64'b0;
//     answer <= 64'b0;
//     A_complete <= 64'b0;
//     A_comp_complete <= 64'b0;
//   end
  integer i;
//   always @ (A or B)
  
  always @ (A or B)
    begin
      flag = 1'b0;
    end
  
  always @ (posedge clk)
    begin
      if(~flag)
        begin
      accumulator <= 64'b0;
    answer <= 64'b0;
    A_complete <= 64'b0;
    A_comp_complete <= 64'b0;
//       accumulator <=64'b0;
          if (~A[31])
            begin
              A_complete = {32'b0,A};
              A_comp_complete = {32'hffffffff,-A};
            end
          else
            begin
              A_complete ={32'hffffffff,A};
              A_comp_complete = {32'b0,-A};
            end
        
      for (i=0;i<32;i = i+1)
        begin
//        $display(answer);
          if(i==0)
            begin
              if (B[0])
                begin
                  accumulator = A_comp_complete;
                  A_complete = A_complete << 1;
                  A_comp_complete = A_comp_complete << 1;
                  
                end
              else
                begin
                  A_complete = A_complete << 1;
                  A_comp_complete = A_comp_complete << 1;
                end
            end
          else
            begin
              if(B[i-1] - B[i] == 1)
                begin
                  accumulator = accumulator + A_complete;
                  A_complete = A_complete << 1;
                  A_comp_complete = A_comp_complete << 1;
                end
              else if (B[i-1] - B[i] == -1)
                begin
                  accumulator = accumulator + A_comp_complete;
                  A_complete = A_complete << 1;
                  A_comp_complete = A_comp_complete << 1;
                end
              else
                begin
                  A_complete = A_complete << 1;
                  A_comp_complete = A_comp_complete << 1;
                end
            end
          
          answer <= accumulator;
        end
    end
      else
    begin
//       answer <= accumulator;
      flag = 1'b1;
    end
    end
  
    
        
  
endmodule
module claAdder(
    input [3:0] x,
    input [3:0] y,
    input cin,
    output [3:0] sum,
    output cout,
    output overflow
    );
  wire cneg1;
    assign cneg1 = cin;
    wire c0,c1,c2,c3,g0,g1,g2,g3,p0,p1,p2,p3;
    assign c0 = x[0]&y[0] | x[0]&cin | y[0]&cin;
    assign p0 = x[0]^y[0];
    assign p1 = x[1]^y[1];
    assign p2 = x[2]^y[2];
    assign p3 = x[3]^y[3];
    assign g0 = x[0] & y[0];
    assign g1 = x[1] & y[1];
    assign g2 = x[2] & y[2];
    assign g3 = x[3] & y[3];
    assign c1 = g1 | (p1&c0);
    assign c2 = g2 | (p2&g1) | p2&p1&c0;
    assign c3 = g3 | p3&c2 | p3&p2&g1 | p3&p2&p1&c0;
    
    assign overflow = c3^c2;
    assign sum[0] = p0 ^ cneg1;
    assign sum[1] = p1 ^ c0;
    assign sum[2] = p2 ^ c1;
    assign sum[3] = p3 ^ c2;
    assign cout =  c3;
endmodule



module cla32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
    output overflow_from_module
    );
    wire [31:0] ans;
    wire carry[7:0];
    wire overflow [7:0];
    claAdder cla1(A[3:0],B[3:0],0,ans[3:0],carry[0],overflow[0]);
    claAdder cla2(A[7:4],B[7:4],carry[0],ans[7:4],carry[1],overflow[1]);
    claAdder cla3(A[11:8],B[11:8],carry[1],ans[11:8],carry[2],overflow[2]);
    claAdder cla4(A[15:12],B[15:12],carry[2],ans[15:12],carry[3],overflow[3]);
    claAdder cla5(A[19:16],B[19:16],carry[3],ans[19:16],carry[4],overflow[4]);
    claAdder cla6(A[23:20],B[23:20],carry[4],ans[23:20],carry[5],overflow[5]);
    claAdder cla7(A[27:24],B[27:24],carry[5],ans[27:24],carry[6],overflow[6]);
    claAdder cla8(A[31:28],B[31:28],carry[6],ans[31:28],carry[7],overflow[7]);
    assign overflow_from_module = overflow[7];
    assign C = ans;
endmodule



module cla32_adder(input [31:0] A,input [31:0] B, output [31:0] answer, output overflow);
    cla32 ADDER(A,B,answer,overflow);
endmodule

module cla32_subtracter(input [31:0] A,input [31:0] B, output [31:0] answer, output overflow);
    wire [31:0] B_complement;
    assign B_complement = ~B + 1;
    cla32 SUBTRACTER(A,B_complement, answer, overflow);
endmodule





module control_unit(input [16:0] opcode, output reg [2:0] enable);
parameter [2:0]
Eadd = 3'b100,
Esub = 3'b010,
Emul = 3'b001,
Edefault = 3'b0;
always @ (opcode)
begin
case(opcode)
17'b00000000000110011: enable <= Eadd;
17'b00000000000010011:enable <= Eadd;
17'b01000000000110011: enable <= Esub;
17'b00000010000110011: enable <= Emul;
default: enable <= Edefault;
endcase
end
endmodule




module alu_with_clk(
input [31:0] A,
input [31:0] B,
input [16:0] opcode,
input clk,
output reg [31:0] UH,
output reg [31:0] LH,
output reg overflow
//output reg alu_clk_reg
    );
    
    parameter [2:0]
    Eadd = 3'b100,
    Esub = 3'b010,
    Emul = 3'b001,
    Edefault = 3'b0;
    
    
    
    
    wire alu_clk;
//     reg change;
//     clk_divider_32 clkdivider(clk,alu_clk);
    
    always @ (A or B or opcode)
//    always @ (posedge clk)    
    begin
//    $display("a and b in alu are ", A, B);
//    $display("opcode is ", opcode);
//       change = 1'b0;
   	 UH <= 32'b0;
   	 LH <= 32'b0;
   	 overflow <= 0;
    end
    
    wire [2:0] enable;
    control_unit CU(opcode,enable);
    
    wire [31:0] LH_from_add;
    wire [31:0] LH_from_sub;
    wire [31:0] LH_from_mul;
    wire overflow_add,overflow_sub;
    wire [31:0] UH_from_mul;
    wire [63:0] mul_ans;
    assign LH_from_mul = mul_ans[31:0];
    assign UH_from_mul = mul_ans[63:32];
    
    cla32_adder ADD(A,B,LH_from_add,overflow_add);
    cla32_subtracter SUB(A,B,LH_from_sub,overflow_sub);
  booth_multiplier MUL(A,B,clk,mul_ans);
  
//  always @ (posedge clk, negedge clk)
  always @ (clk)
    
    begin
//    $display("a and b in alu are ", A, B);
//       change = 0
//       $display(enable);
   	 case(enable)
   	 Eadd:
   	 begin
   		 LH <= LH_from_add;
   		 UH <= 32'b0;
   		 overflow <= overflow_add;
  	 
   	 end
   	 Esub:
   	 begin
   		 LH <= LH_from_sub;
   		 UH <= 32'b0;
   		 overflow <= overflow_sub;
  	 
   	 
   	 end
   	 Emul:
   	 begin
//        change = ~change;
   		 LH <= LH_from_mul;
   		 UH <= UH_from_mul;
   		 overflow <= 1'b0;
   	 end
  	 
  	 
   	 default:
   	 begin
   	 UH <= 32'b0;
   	 LH <= 32'b0;
   	 overflow <= 32'b0;
   	 end
   	 endcase
//   	 $display("output from alu is ", LH);
   	 
    end

endmodule

