`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:09:51
// Design Name: 
// Module Name: data_cache
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


module data_cache(
    input [31:0] address,
    input [31:0] write_value,
    input clk, rst,
    output reg [31:0] read_value
    );
    reg [31:0] d_cache [7:0];
    integer i;
    always @ (posedge clk)
    begin
        if (rst) begin
            for(i=0; i<8; i=i+1) d_cache[i] = 32'h0;
            read_value = 32'h0;
            d_cache[0] = 32'd45;
            d_cache[1] = -20;
        
        end
        else
        begin
            if (address < 8 && address >=0)begin
            read_value = d_cache[address];
            end
            else
            begin
                read_value = 32'h0;
            
            end
        
        end
    
    
    end
    
    
    
    
    
    
    
endmodule









