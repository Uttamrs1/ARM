module arm (
    clk,
    reset,
    i_Sig_Forwarding_Enable,
    w_Flush,
    w_Freeze,
    w_ID_Branch_Taken_Out,
    w_EXE_Branch_Address_In,
    hazard_detected,
    if_pc_in,
    if_instruction_in,
    if_pc_out,
    if_instruction_out,
    id_pc_in,
    id_pc_out,
    id_mem_r_en_in,
    id_mem_w_en_in,
    id_wb_en_in,
    id_status_w_en_in,
    id_branch_taken_in,
    id_imm_in,
    id_exec_cmd_in,
    id_val_rm_in,
    id_val_rn_in,
    id_signed_immed_24_in,
    id_dest_in,
    id_shift_operand_in,
    id_mem_r_en_out,
    id_mem_w_en_out,
    id_wb_en_out,
    id_status_w_en_out,
    id_imm_out,
    id_exec_cmd_out,
    id_val_rm_out,
    id_val_rn_out,
    id_signed_immed_24_out,
    id_dest_out,
    id_shift_operand_out,
    id_carry_out,
    status_out,
    wb_wb_en,
    wb_value,
    wb_dest,
    hazard,
    two_src,
    src_1,
    src_2,
    id_src_1_out,
    id_src_2_out,
    exe_dest_out,
    exe_mem_w_en_out,
    exe_wb_en_out,
    exe_pc_in,
    exe_pc_out,
    exe_alu_status_in,
    exe_wb_en_in,
    exe_mem_r_en_in,
    exe_mem_w_en_in,
    exe_alu_res_in,
    exe_val_rm_in,
    exe_dest_in,
    exe_mem_r_en_out,
    exe_alu_res_out,
    exe_val_rm_out,
    fwd_sel_src_1,
    fwd_sel_src_2,
    mem_pc_in,
    mem_pc_out,
    mem_wb_en_in,
    mem_r_en_in,
    mem_alu_res_in,
    mem_dest_in,
    mem_data_mem_in,
    mem_wb_en_out,
    mem_r_en_out,
    mem_alu_res_out,
    mem_dest_out,
    mem_data_mem_out,
    wb_pc_in
    );

    input clk;
    input reset;
    input i_Sig_Forwarding_Enable;
    input w_Flush;
    input w_Freeze;
    input w_ID_Branch_Taken_Out;
    input [31:0] w_EXE_Branch_Address_In;
    input hazard_detected;

    input [31:0] if_pc_in;
    input [31:0] if_instruction_in;
    output [31:0] if_pc_out;
    output [31:0] if_instruction_out;

    input [31:0] id_pc_in;
    output [31:0] id_pc_out;
    output id_mem_r_en_in;
    output id_mem_w_en_in;
    output id_wb_en_in;
    output id_status_w_en_in;
    output id_branch_taken_in;
    output id_imm_in;
    output [3:0] id_exec_cmd_in;
    output [31:0] id_val_rm_in;
    output [31:0] id_val_rn_in;
    output [23:0] id_signed_immed_24_in;
    output [3:0] id_dest_in;
    output [11:0] id_shift_operand_in;
    output id_mem_r_en_out;
    output id_mem_w_en_out;
    output id_wb_en_out;
    output id_status_w_en_out;
    output id_imm_out;
    output [3:0] id_exec_cmd_out;
    output [31:0] id_val_rm_out;
    output [31:0] id_val_rn_out;
    output [23:0] id_signed_immed_24_out;
    output [3:0] id_dest_out;
    output [11:0] id_shift_operand_out;
    output id_carry_out;
    output [3:0] status_out;
    output wb_wb_en;
    output [31:0] wb_value;
    output [3:0] wb_dest;
    output hazard;
    output two_src;
    output [3:0] src_1;
    output [3:0] src_2;
    output [3:0] id_src_1_out;
    output [3:0] id_src_2_out;

    output [3:0] exe_dest_out;
    output exe_mem_w_en_out;
    output exe_wb_en_out;

    input [31:0] exe_pc_in;
    output [31:0] exe_pc_out;
    input [3:0] exe_alu_status_in;
    output exe_wb_en_in;
    output exe_mem_r_en_in;
    output exe_mem_w_en_in;
    output [31:0] exe_alu_res_in;
    output [31:0] exe_val_rm_in;
    output [3:0] exe_dest_in;
    output exe_mem_r_en_out;
    output [31:0] exe_alu_res_out;
    output [31:0] exe_val_rm_out;
    output [1:0] fwd_sel_src_1;
    output [1:0] fwd_sel_src_2;

    input [31:0] mem_pc_in;
    output [31:0] mem_pc_out;
    output mem_wb_en_in;
    output mem_r_en_in;
    output [31:0] mem_alu_res_in;
    output [3:0] mem_dest_in;
    output [31:0] mem_data_mem_in;
    output mem_wb_en_out;
    output mem_r_en_out;
    output [31:0] mem_alu_res_out;
    output [3:0] mem_dest_out;
    output [31:0] mem_data_mem_out;

    output [31:0] wb_pc_in;

    assign w_Flush       = 1'b0;
    assign w_Freeze      = 1'b0;
    
    // ################################# Instruction Fetch Stage: ###################################
    if_stage IF_Stage (
        .clk(clk), 
        .reset(reset), 
        .i_Freeze(hazard_detected), 
        .i_Branch_Taken(w_ID_Branch_Taken_Out), 
        .i_Branch_Address(w_EXE_Branch_Address_In),
        .o_Pc(if_pc_in), 
        .o_Instruction(if_instruction_in)
    );

    if_stage_reg IF_Stage_Reg (
        .clk(clk), 
        .reset(reset), 
        .i_Flush(w_ID_Branch_Taken_Out), 
        .i_Freeze(hazard_detected),
        .i_Pc(if_pc_in), 
        .i_Instruction(if_instruction_in),
        .o_Pc(if_pc_out), 
        .o_Instruction(if_instruction_out)
    );
    // ################################## Instruction Decode Stage #################################
    id_stage ID_Stage (
        .clk(clk), 
        .reset(reset),
        .i_Pc(if_pc_out),
        .i_Instruction(if_instruction_out),
        .i_Status(status_out),
        .i_Sig_Write_Back(wb_wb_en), 
        .i_Write_Back_Value(wb_value),
        .i_Write_Back_Destination(wb_dest),
        .i_Sig_Hazard(hazard_detected),
        .o_Pc(id_pc_in),
        .o_Sig_Memory_Read_Enable(id_mem_r_en_in), 
        .o_Sig_Memory_Write_Enable(id_mem_w_en_in), 
        .o_Write_Back_Enable(id_wb_en_in), 
        .i_Status_Write_Enable(id_status_w_en_in), 
        .o_Sig_Branch_Taken(id_branch_taken_in), 
        .o_Immediate(id_imm_in),
        .o_Sigs_Control(id_exec_cmd_in),
        .o_Rm_Value(id_val_rm_in), 
        .o_Rn_Value(id_val_rn_in),
        .o_Signed_Immediate_24(id_signed_immed_24_in),
        .o_Destination(id_dest_in),
        .o_Shift_Operand(id_shift_operand_in),
        .o_Two_Src(two_src),
        .o_Rn(src_1), 
        .o_Src_2(src_2)
    );

    id_stage_reg ID_Stage_Reg(
        .clk(clk), 
        .reset(reset), 
        .i_Flush(w_ID_Branch_Taken_Out), 
        .i_Freeze(w_Freeze),
        .i_Pc(id_pc_in), 
        .i_Sig_Memory_Read_Enable( id_mem_r_en_in), 
        .i_Sig_Memory_Write_Enable(id_mem_w_en_in), 
        .i_Sig_Write_Back_Enable(id_wb_en_in), 
        .i_Sig_Status_Write_Enable(id_status_w_en_in), 
        .i_Branch_Taken(id_branch_taken_in), 
        .i_Immediate(id_imm_in),
        .i_Sigs_Control(id_exec_cmd_in),
        .i_Value_Rm(id_val_rm_in), 
        .i_Value_Rn(id_val_rn_in),
        .i_Signed_Immediate_24(id_signed_immed_24_in),
        .i_Destination(id_dest_in),
        .i_Shift_Operand(id_shift_operand_in),
        .i_Carry_In(status_out[2]),
        .i_Src_1(src_1), 
        .i_Src_2(src_2),
        .o_Pc(id_pc_out),
        .o_Sig_Memory_Read_Enable(id_mem_r_en_out), 
        .o_Sig_Memory_Write_Enable(id_mem_w_en_out), 
        .o_Sig_Write_Back_Enable(id_wb_en_out), 
        .o_Sig_Status_Write_Enable(id_status_w_en_out), 
        .o_Branch_Taken(w_ID_Branch_Taken_Out), 
        .o_Immediate(id_imm_out),
        .o_Sigs_Control(id_exec_cmd_out),
        .o_Value_Rm(id_val_rm_out), 
        .o_Value_Rn(id_val_rn_out),
        .o_Signed_Immediate_24(id_signed_immed_24_out),
        .o_Destination(id_dest_out),
        .o_Shift_Operand(id_shift_operand_out),
        .o_Carry(id_carry_out),
        .o_Src_1(id_src_1_out), 
        .o_Src_2(id_src_2_out)
    );
    // ################################### Hazard ################################ 
    hazard_detection_unit Hazard_Detection_Unit(
        .clk(clk), 
        .reset(reset),
        .i_Sig_Memory_Write_Back_Enable(exe_wb_en_out),
        .i_Memory_Destination(exe_dest_out),
        .i_Sig_Exe_Write_Back_Enable(id_wb_en_out),
        .i_Exe_Destination(id_dest_out),
        .i_Src_1(src_1),
        .i_Src_2(src_2),
        .i_Two_Src(two_src),
        .i_Sig_Forward_Enable(i_Sig_Forwarding_Enable), 
        .i_Sig_Exe_Memory_Read_Enable(id_mem_r_en_out),
        .o_Sig_Hazard_Detected(hazard_detected)
    );
    // ################################### Executaion Stage ################################
    exe_stage EXE_Stage (
        .clk(clk), 
        .reset(reset),
        .i_Pc(id_pc_out),
        .i_Sig_Memory_Read_Enable(id_mem_r_en_out), 
        .i_Sig_Memory_Write_Enable(id_mem_w_en_out), 
        .i_Sig_Write_Back_Enable(id_wb_en_out), 
        .i_Immediate(id_imm_out),
        .i_Carry_In(id_carry_out),
        .i_Shift_Operand(id_shift_operand_out),
        .i_Sigs_Control(id_exec_cmd_out),
        .i_Val_Rm(id_val_rm_out), 
        .i_Val_Rn(id_val_rn_out),
        .i_Signed_Immediate_24(id_signed_immed_24_out),
        .i_Destination(id_dest_out),
        .i_Sel_Src_1(fwd_sel_src_1),
        .i_Sel_Src_2(fwd_sel_src_2),
        .i_Memory_Write_Back_Value(exe_alu_res_out),
        .i_Write_Back_Write_Back_Value(wb_value),
        .o_Branch_Address(w_EXE_Branch_Address_In),
        .o_ALU_Status(exe_alu_status_in),
        .o_Pc(exe_pc_in),
        .o_Sig_Write_Back_Enable(exe_wb_en_in), 
        .o_Sig_Memory_Read_Enable(exe_mem_r_en_in), 
        .o_Sig_Memory_Write_Enable(exe_mem_w_en_in),
        .o_ALU_Result(exe_alu_res_in),
        .o_Val_Rm(exe_val_rm_in),
        .o_Destination(exe_dest_in)
    );

    exe_stage_reg EXE_Stage_Reg (
        .clk(clk), 
        .reset(reset), 
        .i_Flush(w_Flush), 
        .i_Freeze(w_Freeze),
        .i_Pc(exe_pc_in), 
        .i_Sig_Write_Back_Enable(exe_wb_en_in),
        .i_Sig_Memory_Read_Enable(exe_mem_r_en_in), 
        .i_Sig_Memory_Write_Enable(exe_mem_w_en_in),
        .i_ALU_Result(exe_alu_res_in),
        .i_Value_Rm(exe_val_rm_in),
        .i_Destination(exe_dest_in),
        .o_Pc(exe_pc_out),
        .o_Sig_Write_Back_Enable(exe_wb_en_out), 
        .o_Sig_Memory_Read_Enable(exe_mem_r_en_out), 
        .o_Sig_Memory_Write_Enable(exe_mem_w_en_out),
        .o_ALU_Result(exe_alu_res_out),
        .o_Value_Rm(exe_val_rm_out),
        .o_Destination(exe_dest_out)
    );
    // ################################# Status Register ############################################
    status_register Status_Register (
        .clk(clk), 
        .reset(reset),
        .i_Memory_Ins(id_status_w_en_out),
        .i_Status(exe_alu_status_in),
        .o_Status(status_out)
    );
    // ################################# Memory Stage ############################################
    mem_stage MEM_Stage (
        .clk(clk), 
        .reset(reset), 
        .i_Pc(exe_pc_out), 
        .i_Sig_Write_Back_Enable(exe_wb_en_out), 
        .i_Sig_Memory_Read_Enable(exe_mem_r_en_out), 
        .i_Sig_Memory_Write_Enable(exe_mem_w_en_out),
        .i_ALU_Result(exe_alu_res_out),
        .i_Value_Rm(exe_val_rm_out),
        .i_Destination(exe_dest_out),
        .o_Pc(mem_pc_in),
        .o_Sig_Write_Back_Enable(mem_wb_en_in),
        .o_Sig_Memory_Read_Enable(mem_r_en_in),
        .o_Memory_Result(mem_alu_res_in),
        .o_Destination(mem_dest_in),
        .o_Data_Memory(mem_data_mem_in)
    );

    mem_stage_reg MEM_Stage_Reg (
        .clk(clk), 
        .reset(reset), 
        .i_Flush(w_Flush), 
        .i_Freeze(w_Freeze),
        .i_Pc(mem_pc_in), 
        .i_Sig_Write_Back_Enable(mem_wb_en_in), 
        .i_Sig_Memory_Read_Enable(mem_r_en_in), 
        .i_ALU_Result(mem_alu_res_in),
        .i_Destination(mem_dest_in),
        .i_Data_Memory(mem_data_mem_in),
        .o_Pc(mem_pc_out),
        .o_Sig_Write_Back_Enable(mem_wb_en_out), 
        .o_Sig_Memory_Read_Enable(mem_r_en_out),
        .o_ALU_Result(mem_alu_res_out),
        .o_Destination(mem_dest_out),
        .o_Data_Memory(mem_data_mem_out)
    );
    // ################################### Write Block Stage #######################################
    wb_stage WB_Stage(
        .clk(clk), 
        .reset(reset),
        .i_Pc(mem_pc_out),
        .i_Sig_Write_Back_Enable(mem_wb_en_out), 
        .i_Sig_Memory_Read_Enable(mem_r_en_out), 
        .i_ALU_Result(mem_alu_res_out),
        .i_Destination(mem_dest_out),
        .i_Data_Memory(mem_data_mem_out),
        .o_Pc(wb_pc_in),
        .o_Sig_Write_Back_Enable(wb_wb_en), 
        .o_Write_Back_Value(wb_value),
        .o_Destination(wb_dest)
    );
    // ################################### Forwarding Unit #######################################
    forwarding_unit Forwarding_Unit (
        .i_Forwarding_Enable(i_Sig_Forwarding_Enable),
        .i_Src_1(id_src_1_out), 
        .i_Src_2(id_src_2_out),
        .i_Write_Back_Destination(wb_dest), 
        .i_Memory_Destination(mem_dest_in),
        .i_Sig_Write_Back_Write_Back_Enable(wb_wb_en), 
        .i_Sig_Memory_Write_Back_Enable(mem_wb_en_in),
        .o_Sel_Src_1(fwd_sel_src_1), 
        .o_Sel_Src_2(fwd_sel_src_2)
    );

endmodule
