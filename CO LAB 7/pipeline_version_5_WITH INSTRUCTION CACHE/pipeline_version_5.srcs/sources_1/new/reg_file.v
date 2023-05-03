`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:06:21
// Design Name: 
// Module Name: reg_file
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

module reg_file(
//    input [31:0] instruction,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
//    input enable_read,
    input enable_write,
    input [31:0] write_value,
    input clk,
    input rst,
    input enable,
    
    
    output reg [31:0] read_value_1,
    output reg [31:0] read_value_2
    );
    reg [31:0] register_file [31:0];
//    always @ (rs1 or rs2 or rd or enable_write)
//    begin
//    end
    
    integer i;
    always @(posedge clk)
    begin
        if(enable == 1)
        begin
            $display("");
            $display("x10 is %b ", register_file[10]);
            $display("x27 is %b", register_file[27]);
            $display("x28 is %b", register_file[28]);
            $display("x29 is %b" , register_file[29]);
            $display("x30 is %b", register_file[30]);
            $display("");
            if(rst)
            begin
                for(i=0;i<32;i = i+1)
                begin
                    register_file[i] = 32'h0;
                end
            end
            
            else
            begin
                case(enable_write)
                // if enable_write is 1
                    1'b1:
                    begin
                        
                        case(rd)
                        //if address is zero write will not happen since x0 hardcoded to zero
                            5'b0:
                            begin
                                read_value_1 <= 32'h0;
                                read_value_2 <= 32'h0;
                            end
                            
                            //any address other than 0
                            default:
                            begin
                                read_value_1 <= 32'h0;
                                read_value_2 <= 32'h0;
                                register_file[rd] <= write_value;
                            end
                        endcase
                    end
                    
                    
                    // if enable_write is 0
                    1'b0:
                    begin
                        read_value_1 <= register_file[rs1];
                        read_value_2 <= register_file[rs2];
                    end
                    default:
                    begin
                    
                    end
                 
                
                
                
                endcase
            
            end
        
        end
        
        else
        // if register is not enabled,
        // that is, enable input is 0
        begin
        
        read_value_1 <= 32'b0;
        read_value_2 <= 32'b0;
        end
    
    end
    
    
    
endmodule

