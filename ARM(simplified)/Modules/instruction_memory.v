module instruction_memory(
    clk,
    reset,
    i_Address, 
    o_Instruction
    );

    parameter DATA_WIDTH = 32;

    input clk;
    input reset;
    input [DATA_WIDTH - 1:0] i_Address;

    output reg [DATA_WIDTH - 1:0] o_Instruction;
    
    reg [7:0] memory [0:1023];

    // Simple ARM Instructions
    initial begin
        // MOV R0, #20
        {memory[0], memory[1], memory[2], memory[3]} = 32'b1110_00_1_1101_0_0000_0000_000000010100; 

        // ADD R1, R2, R3
        {memory[4], memory[5], memory[6], memory[7]} = 32'b1110_00_0_010_0001_0000_0000_0000_0000_0010; 

        // SUB R4, R5, R6
        {memory[8], memory[9], memory[10], memory[11]} = 32'b1110_00_0_001_0100_0000_0000_0000_0000_0110; 

        // LDR R7, [R8, #4]
        {memory[12], memory[13], memory[14], memory[15]} = 32'b1110_01_1_010_0111_0000_0000_0000_0000_0100; 

        // STR R9, [R10, #8]
        {memory[16], memory[17], memory[18], memory[19]} = 32'b1110_00_0_100_1001_0000_0000_0000_0000_1000; 

        // BNE 0x10
        {memory[20], memory[21], memory[22], memory[23]} = 32'b1110_01_0_101_1111_1111_1111_0000_0001_0000; 

        // CMP R11, R12
        {memory[24], memory[25], memory[26], memory[27]} = 32'b1110_00_0_101_1011_0000_0000_0000_0000_1100; 

        // MOV R13, R14
        {memory[28], memory[29], memory[30], memory[31]} = 32'b1110_00_1_110_1101_0000_0000_0000_0000_1110; 
    end

    always @(*) begin
        if (reset) begin
            o_Instruction <= 32'b0;
            {memory[0], memory[1], memory[2], memory[3]} = 32'b1110_00_1_1101_0_0000_0000_000000010100; //MOV R0 ,#20 //R0 = 20
        end
        else begin
            o_Instruction <= {memory[i_Address], memory[i_Address+1], memory[i_Address+2], memory[i_Address+3]};
        end
    end

endmodule
