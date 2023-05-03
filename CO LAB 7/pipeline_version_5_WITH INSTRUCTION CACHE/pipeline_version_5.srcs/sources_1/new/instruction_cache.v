`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:09:36
// Design Name: 
// Module Name: instruction_cache
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


module instruction_cache(
    input clk, rst, 
    output reg [31:0] instruction
    );
    reg [31:0] i_cache [7:0];
    integer i;
    reg flag;
    reg [3:0] count;
    
    // counter
    always @ (posedge clk)
    begin
    if (rst) count <= 4'b0;
    else count <= count+1;
    end
    
    
    always @(posedge clk)
    begin
        if (rst)
        begin
            for(i=0;i<8;i = i+1) i_cache[i] = 32'h0;
            flag = 1'b0;
            
        end
        else
        begin
            if (~flag) begin
                if (count == 8) flag = 1'b1;
                else
                begin
                    instruction <= i_cache[count];
                end
            
            end
            else
            begin
                flag <= 1'b1;
            end
        end
    
    end
    
    
endmodule
