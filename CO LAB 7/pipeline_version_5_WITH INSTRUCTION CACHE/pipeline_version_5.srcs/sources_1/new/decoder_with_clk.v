`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:08:39
// Design Name: 
// Module Name: decoder_with_clk
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



module decoder_with_clk(
    input [31:0] instruction,
    input clk,
    output reg [16:0] opcode,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [11:0] immediate,
    output reg [3:0] risl_type
    // ri type is an indicator of whether it is r-type or i-type
    
);
// if instruction is r-type, ri_type=10, if i-type, ri_type = 01, if invalid, ri_type = 00

parameter [3:0]
R_type = 4'b1000,
I_type = 4'b0100,
S_type = 4'b0010,
L_type = 4'b0001;


//always @ (posedge clk, negedge clk)

always @(clk)
//always @ (instruction)
begin
//$display("received instruction is ", instruction);
//opcode <= {instruction[6:0]};
rd = instruction[11:7];
rs1 = instruction[19:15];
//in both r type and i type these are the same
case (instruction[6:0])
//when opcode is 0110011, it is R-Type
7'b0110011:
begin
opcode <= {instruction[31:25],instruction[14:12], instruction[6:0]};
rs2 <= instruction[24:20];
immediate <= 12'b0;
risl_type <= R_type;

end

// when opcode is 00000111 or 0010011 or 1100111, it is I-type
7'b0000011:
begin
opcode = {7'b0,instruction[14:12], instruction[6:0]};

immediate = instruction[31:20];
rs2 = 5'b0;
risl_type = I_type;
    // for load instruction
    case(instruction[14:12])
        3'b010: begin
            risl_type = L_type;
            
        end
        default:begin
        
        end
        
        
    endcase



end
  7'b0010011:
begin
opcode <= {7'b0,instruction[14:12], instruction[6:0]};

immediate <= instruction[31:20];
rs2 <= 5'b0;
risl_type <= I_type;

end
  7'b1100111:
begin
opcode <= {7'b0,instruction[14:12], instruction[6:0]};

immediate <= instruction[31:20];
rs2 <= 5'b0;
risl_type <= I_type;

end

// S_type if opcode is 0100011
7'b0100011: begin
    rd <= 5'b0;
    opcode <= {7'b0,instruction[14:12], instruction[6:0]};

    immediate <= {instruction[31:25], instruction[11:7]};
    rs2 <= instruction[24:20];
    risl_type <= S_type;

end


// invalid opcode
  default:
begin
opcode <= 17'b0;
immediate <= 0;
rs2 <=0;
risl_type <= 2'b00;
rd <= 0;
rs1 <= 0;

end


endcase
//$display("from decoder ",opcode, rs1, rs2, rd, immediate); 
end
  endmodule


