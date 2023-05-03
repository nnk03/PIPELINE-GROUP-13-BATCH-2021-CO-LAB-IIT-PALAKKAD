`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:03:38
// Design Name: 
// Module Name: pipeline
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


module pipeline(
    input [255:0] instruction,
    input clk, rst,
    output reg [31:0] rv1, rv2, imm, ans_from_alu,current_instruction,
    output reg [3:0] risl_type_register
    );
    reg [31:0] pipeline_1;
    reg [31:0] pipeline_2 [2:0];
    reg [31:0] pipeline_3 [1:0];
    wire [16:0] opcode_wire;
    wire [4:0] rs1_wire, rs2_wire, rd_wire;
    reg [4:0] destination_register;
    wire [11:0] immediate_wire;
    wire [3:0] risl_type_wire;    
    
    parameter [3:0]
    R_type = 4'b1000,
    I_type = 4'b0100,
    S_type = 4'b0010,
    L_type = 4'b0001;
    reg [31:0] data_cache [7:0];
    
    
    
    
    decoder_with_clk DECODER(pipeline_1,clk,  opcode_wire, rs1_wire, rs2_wire, rd_wire, immediate_wire, risl_type_wire);
    
    reg [4:0] rs1, rs2, rd;
    reg enable_write, enable;
    reg [31:0] write_value;
    wire [31:0] read_value_1_wire, read_value_2_wire;
    always @ (posedge clk)
    begin 
    enable <= 1'b1;
    end
    
//    reg_file REGISTER_FILE(rs1_wire, rs2_wire, rd_wire, enable_write, write_value, clk, rst, enable, read_value_1_wire, read_value_2_wire);
      reg_file REGISTER_FILE(rs1_wire, rs2_wire, destination_register , enable_write, write_value, clk, rst, enable, read_value_1_wire, read_value_2_wire);

    
    reg [31:0] A, B;
    wire [31:0] UH_wire, LH_wire;
    wire overflow;
    reg [4:0] data_cache_address;
    
    
    alu_with_clk ALU(A, B, opcode_wire, clk, UH_wire, LH_wire, overflow_wire);
    
//    always @
//    reg store_instruction;
//    reg load_instruction;
    reg [1:0] load_store;
    
    
    parameter [2:0]
    STAGE_1 = 3'd1,
    STAGE_2 = 3'd2,
    STAGE_3 = 3'd3,
    STAGE_4 = 3'd4;
    
    reg [2:0] stage;
    
    always @ (posedge clk) begin
        rv1 <= read_value_1_wire;
        rv2 <= read_value_2_wire;
        imm <= immediate_wire;
        ans_from_alu <= LH_wire;
        risl_type_register <= risl_type_wire;
        
        
    
    end
    
    always @ (posedge clk) begin
        case(risl_type_wire)
        S_type: load_store = 2'b01;
        L_type: load_store = 2'b10;
        default: load_store = 2'b00;
            
        
        endcase
    
    
    end
    
    reg [31:0] instruction_cache [7:0];
    reg [3:0] program_counter;
    
    
    
    reg [31:0] temp;
    integer i;
    always @ (posedge clk) begin
        if (rst) begin
            stage = 3'd1;
            for (i=0;i<8;i=i+1) data_cache[i] = 32'h0; 
            load_store = 2'b0;
            data_cache[0] = 45;
            data_cache[1] = -20;
            program_counter = 4'b0;
            for (i=0;i<8;i = i + 1) instruction_cache[i] = 32'h0;
            instruction_cache[0] = instruction[31:0];
            instruction_cache[1] = instruction[63:32];
            instruction_cache[2] = instruction[95:64];
            instruction_cache[3] = instruction[127:96];
            instruction_cache[4] = instruction[159:128];
            instruction_cache[5] = instruction[191:160];
            instruction_cache[6] = instruction[223:192];
            instruction_cache[7] = instruction[255:224];
//            for(i=0; i<8; i=i+1) $display("INSTRUCTION FROM PIPELINE IS ", instruction_cache[i]);
        
        end
        else begin
        
            case(stage)
                STAGE_1: begin
                    if(program_counter == 9) begin
                        stage = STAGE_1;
                        pipeline_1 = 32'h0;
                    end
                
                else begin
                
//                    pipeline_1 = instruction[31: 0];
                    pipeline_1 = instruction_cache[program_counter];
                    current_instruction = pipeline_1;
                    program_counter = program_counter + 1;
                    enable_write = 1'b0;
//                    pipeline_1 = instruction;
                    data_cache_address = 5'h0;
                    $display("instruction is ",pipeline_1);
    //                $display("first cycle");
                    stage = STAGE_2;
                end
                
                
                end
                STAGE_2: begin
                // waiting for output from decoder
//                $display("second cycle");
//                $display("output from decoder is, %b %d %d %d %d %b", opcode_wire, rs1_wire, rs2_wire, rd_wire, immediate_wire, risl_type_wire);
                enable_write = 1'b0;
//                A = read_value_1_wire;
////                B = read_value_2_wire;
//                case(risl_type_wire)
//                    R_type: B = read_value_2_wire;
//                    I_type: begin
//                            if (~immediate_wire[11]) B = {20'b0, immediate_wire};
//                            else B = {20'hfffff, immediate_wire};
//                    end
//                    default: B = 32'b0;
                    
                    
//                endcase

                stage = STAGE_3;
//                $display("A and B are    ",A, B);
                
                end
                STAGE_3: begin
                A = read_value_1_wire;
//                $display(" A is ", A);
//                B = read_value_2_wire;
                case(risl_type_wire)
                    R_type: 
                    begin
                    B = read_value_2_wire;
                    destination_register = rd_wire;
                    end
                    I_type: begin
                    
                            destination_register = rd_wire;
                            if (~immediate_wire[11]) B = {20'b0, immediate_wire};
                            else B = {20'hfffff, immediate_wire};
                            
                    end
                    S_type:begin
                    
                        destination_register = rd_wire;
                        temp = read_value_2_wire;
                        
                        
                        if (~immediate_wire[11]) B = {20'b0, immediate_wire};
                            else B = {20'hfffff, immediate_wire};
//                        $display(" A and B for store instruction are ", A, B);
//                        $display("rv1 is ", read_value_1_wire);
                        
                        
                        data_cache_address = B + temp;
//                        $display("dca is ..........",data_cache_address);
                    
                    end
                    L_type:
                    begin
                        temp = read_value_1_wire;
                        if (~immediate_wire[11]) B = {20'b0, immediate_wire};
                            else B = {20'hfffff, immediate_wire};
                        
                    
                    end
                    
                    
                    default: 
                    begin
                    B = 32'b0;
                    destination_register = rd_wire;
                    
                    end
                    
                    
                    
                endcase
//                $display("A and B are    ",A, B);
                    stage = STAGE_4;
//                    enable_write = 1'b1;
////                    $display("output from decoder in the third cycle is ", opcode_wire, rs1_wire, rs2_wire, rd_wire, immediate_wire, read_value_1_wire, read_value_2_wire, risl_type_wire);
//                    write_value = LH_wire;
////                    $display("lh wire in third cycle is ", LH_wire);
////                    $display("write value is ",write_value);
////                    $display("rd wire, enable write, write value are ", rd_wire, enable_write, write_value);
//                    stage = STAGE_1;
                
                
                end
                STAGE_4: begin
//                $display("LH wire in 4th cycle is ",LH_wire);
//                            enable_write = 1'b1;
//                    $display("output from decoder in the third cycle is ", opcode_wire, rs1_wire, rs2_wire, rd_wire, immediate_wire, read_value_1_wire, read_value_2_wire, risl_type_wire);
//                    write_value = LH_wire;
//                    $display("lh wire in third cycle is ", LH_wire);
//                    $display("write value is ",write_value);
//                    $display("rd wire, enable write, write value are ", rd_wire, enable_write, write_value);
                    
                    
                    case(load_store)
                        2'b10:begin
                        // load instruction
                        enable_write = 1'b1;
                        // lh wire from alu is the address from where we have to take the value from data cache and place it in destination register
                        destination_register = rd_wire;
                        write_value = data_cache[temp+B];
//                        $display("temp+B and LH_wire is %d %d", temp+B, LH_wire); 
                        $display("write value is ", write_value);
                        
                        
                        end
                        2'b01:
                        begin
                        //store instruction
//                        enable_write = 1'b1;
                        enable_write = 1'b0;
//                        write_value
                        // address is in lh wire, we have to write the read data from register file to data cache[lh wire]
                        data_cache[data_cache_address] = A;                        
                        
                        end
                        default:
                        begin
                            enable_write = 1'b1;
                            write_value = LH_wire;
                            
                        
                        end
                        
                        
                    endcase
                    stage = STAGE_1;
                    for (i=0;i<8;i=i+1) $display("%d value is %b",i, data_cache[i]);
                    
                
                
                end
                
                default: begin
                end
            
            
            
            endcase
        
        
        
        
        
        end
    end
    
    

    
    
    
    
    
    
endmodule














