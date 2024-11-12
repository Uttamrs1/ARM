module tb_arm;

    // Inputs
    reg clk;
    reg reset;
    reg i_Sig_Forwarding_Enable;
    reg w_Flush;
    reg w_Freeze;
    reg w_ID_Branch_Taken_Out;
    reg [31:0] w_EXE_Branch_Address_In;
    reg hazard_detected;

    reg [31:0] if_pc_in;
    reg [31:0] if_instruction_in;

    reg [31:0] id_pc_in;

    // Outputs
    wire [31:0] if_pc_out;
    wire [31:0] if_instruction_out;

    wire [31:0] id_pc_out;
    wire id_mem_r_en_in;
    wire id_mem_w_en_in;
    wire id_wb_en_in;
    wire id_status_w_en_in;
    wire id_branch_taken_in;
    wire id_imm_in;
    wire [3:0] id_exec_cmd_in;
    wire [31:0] id_val_rm_in;
    wire [31:0] id_val_rn_in;
    wire [23:0] id_signed_immed_24_in;
    wire [3:0] id_dest_in;
    wire [11:0] id_shift_operand_in;

    wire id_mem_r_en_out;
    wire id_mem_w_en_out;
    wire id_wb_en_out;
    wire id_status_w_en_out;
    wire id_imm_out;
    wire [3:0] id_exec_cmd_out;
    wire [31:0] id_val_rm_out;
    wire [31:0] id_val_rn_out;
    wire [23:0] id_signed_immed_24_out;
    wire [3:0] id_dest_out;
    wire [11:0] id_shift_operand_out;
    wire id_carry_out;
    wire [3:0] status_out;

    wire wb_wb_en;
    wire [31:0] wb_value;
    wire [3:0] wb_dest;
    wire hazard;
    wire two_src;
    wire [3:0] src_1;
    wire [3:0] src_2;

    wire [3:0] exe_dest_out;
    wire exe_mem_w_en_out;
    wire exe_wb_en_out;

    wire [31:0] exe_pc_out;
    wire exe_mem_r_en_out;
    wire exe_mem_w_en_out;
    wire [31:0] exe_alu_res_out;
    wire [31:0] exe_val_rm_out;

    wire [1:0] fwd_sel_src_1;
    wire [1:0] fwd_sel_src_2;

    wire [31:0] mem_pc_out;
    wire mem_wb_en_out;
    wire mem_r_en_out;
    wire [31:0] mem_alu_res_out;
    wire [3:0] mem_dest_out;
    wire [31:0] mem_data_mem_out;

    wire [31:0] wb_pc_in;

    // Instantiate the arm module
    arm arm1 (
        .clk(clk),
        .reset(reset),
        .i_Sig_Forwarding_Enable(i_Sig_Forwarding_Enable),
        .w_Flush(w_Flush),
        .w_Freeze(w_Freeze),
        .w_ID_Branch_Taken_Out(w_ID_Branch_Taken_Out),
        .w_EXE_Branch_Address_In(w_EXE_Branch_Address_In),
        .hazard_detected(hazard_detected),

        .if_pc_in(if_pc_in),
        .if_instruction_in(if_instruction_in),
        .if_pc_out(if_pc_out),
        .if_instruction_out(if_instruction_out),

        .id_pc_in(id_pc_in),
        .id_pc_out(id_pc_out),
        .id_mem_r_en_in(id_mem_r_en_in),
        .id_mem_w_en_in(id_mem_w_en_in),
        .id_wb_en_in(id_wb_en_in),
        .id_status_w_en_in(id_status_w_en_in),
        .id_branch_taken_in(id_branch_taken_in),
        .id_imm_in(id_imm_in),
        .id_exec_cmd_in(id_exec_cmd_in),
        .id_val_rm_in(id_val_rm_in),
        .id_val_rn_in(id_val_rn_in),
        .id_signed_immed_24_in(id_signed_immed_24_in),
        .id_dest_in(id_dest_in),
        .id_shift_operand_in(id_shift_operand_in),

        .id_mem_r_en_out(id_mem_r_en_out),
        .id_mem_w_en_out(id_mem_w_en_out),
        .id_wb_en_out(id_wb_en_out),
        .id_status_w_en_out(id_status_w_en_out),
        .id_imm_out(id_imm_out),
        .id_exec_cmd_out(id_exec_cmd_out),
        .id_val_rm_out(id_val_rm_out),
        .id_val_rn_out(id_val_rn_out),
        .id_signed_immed_24_out(id_signed_immed_24_out),
        .id_dest_out(id_dest_out),
        .id_shift_operand_out(id_shift_operand_out),
        .id_carry_out(id_carry_out),
        .status_out(status_out),

        .wb_wb_en(wb_wb_en),
        .wb_value(wb_value),
        .wb_dest(wb_dest),
        .hazard(hazard),
        .two_src(two_src),
        .src_1(src_1),
        .src_2(src_2),

        .exe_dest_out(exe_dest_out),
        .exe_mem_w_en_out(exe_mem_w_en_out),
        .exe_wb_en_out(exe_wb_en_out),

        .exe_pc_out(exe_pc_out),
        .exe_mem_r_en_out(exe_mem_r_en_out),
       
        .exe_alu_res_out(exe_alu_res_out),
        .exe_val_rm_out(exe_val_rm_out),

        .fwd_sel_src_1(fwd_sel_src_1),
        .fwd_sel_src_2(fwd_sel_src_2),

        .mem_pc_out(mem_pc_out),
        .mem_wb_en_out(mem_wb_en_out),
        .mem_r_en_out(mem_r_en_out),
        .mem_alu_res_out(mem_alu_res_out),
        .mem_dest_out(mem_dest_out),
        .mem_data_mem_out(mem_data_mem_out),

        .wb_pc_in(wb_pc_in)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        i_Sig_Forwarding_Enable = 1'b0;
        w_Flush = 1'b0;
        w_Freeze = 1'b0;
        w_ID_Branch_Taken_Out = 1'b0;
        w_EXE_Branch_Address_In = 32'h0;
        hazard_detected = 1'b0;

        if_pc_in = 32'h0;
        if_instruction_in = 32'h0;
        id_pc_in = 32'h0;

        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Apply some test values and simulate the module
        #10 if_pc_in = 32'h100;
        if_instruction_in = 32'hF00D;
        id_pc_in = 32'h200;

        // Wait for a few cycles and observe results
        #50;

        // Test hazard detection
        hazard_detected = 1'b1;
        #50;

        // Test forwarding enable
        i_Sig_Forwarding_Enable = 1'b1;
        #50;

        // Test branch taken
        w_ID_Branch_Taken_Out = 1'b1;
        #50;
        
        // Finish the test
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %t, if_pc_out: %h, id_pc_out: %h, hazard: %b" ,"exe_alu_res_out: %b", $time, if_pc_out, id_pc_out, hazard,exe_alu_res_out);
    end

endmodule
