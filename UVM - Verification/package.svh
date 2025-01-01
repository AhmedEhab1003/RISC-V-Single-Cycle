package risc_tb_pkg;

typedef enum logic [3:0]  {R,I,B,J,S, UNKNOWN_TYPE} ins_type;

typedef enum logic [4:0]  {ADD,SUB,AND,OR,
                           ADDI,ANDI,ORI,LW,
                           JALR,BEQ,BNE,JAL,SW, UNKNOWN} ins_name;



function automatic void get_name_type (logic [31:0] instruction, ref ins_name NAME, ref ins_type TYPE, ref [4:0] rd);

  logic [6:0] opcode = instruction[6:0];   
  logic [2:0] funct3 = instruction[14:12];  
  logic [6:0] funct7 = instruction[31:25];  


  // Decode based on opcode
  case (opcode)
    7'b0110011: begin // R-Type Instructions
      TYPE = R;
      rd = instruction[11:7];
      case ({funct7, funct3})
        10'b0000000_000: NAME = ADD;
        10'b0100000_000: NAME = SUB;
        10'b0000000_111: NAME = AND;
        10'b0000000_110: NAME = OR;    
        default: NAME = UNKNOWN;
      endcase
    end

    7'b0010011: begin // I-Type Instructions
      TYPE = I;
      rd = instruction[11:7];
      case (funct3)
        3'b000: NAME = ADDI;  // ADDI
        3'b110: NAME = ORI;   // ORI
        3'b111: NAME = ANDI;  // ANDI
        default: NAME = UNKNOWN;
      endcase
    end

    7'b0000011: begin // I-Type Load Instruction
      TYPE = I;
      rd = instruction[11:7];
      if (funct3 == 3'b010)
        NAME = LW; // Load Word
      else
        NAME = UNKNOWN;
    end

    7'b1100111: begin // I-Type JALR Instruction
      TYPE = I;
      rd = instruction[11:7];
      if (funct3 == 3'b000)
        NAME = JALR; // JALR
      else
        NAME = UNKNOWN;
    end

    7'b0100011: begin // S-Type Instructions
      TYPE = S;
      if (funct3 == 3'b010)
        NAME = SW; // Store Word
      else
        NAME = UNKNOWN;
    end

    7'b1101111: begin // J-Type Instruction
      rd = instruction[11:7];
      TYPE = J;
      NAME = JAL; // JAL
    end

    7'b1100011: begin // B-Type Instructions
      TYPE = B;
      case (funct3)
        3'b000: NAME = BEQ; // Branch Equal
        3'b001: NAME = BNE; // Branch Not Equal
        default: NAME = UNKNOWN;
      endcase
    end

    default: begin
      NAME = UNKNOWN;
      TYPE = UNKNOWN_TYPE;
    end
  endcase
endfunction

function automatic logic [31:0] sign_extend(input logic [11:0] in_value);
  if (in_value[11] == 1) 
    return { 20'b11111111111111111111, in_value };
  else 
    return { 20'b00000000000000000000, in_value };
endfunction

function automatic logic [31:0] sign_extend_20b(input logic [19:0] in_value);
  if (in_value[19] == 1) 
    return { 12'b111111111111, in_value };
  else 
    return { 12'b000000000000, in_value };
endfunction


endpackage