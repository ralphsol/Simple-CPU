library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port (
        clk, reset:			in  STD_LOGIC;
        aBusX: out STD_LOGIC_VECTOR(7 downto 0);
        dBusX: out STD_LOGIC_VECTOR(15 downto 0);
        mem_rwX, mem_enX, mem_enwX: out STD_LOGIC;
    );
end top_level;

architecture topArch of top_level is

component ram is
    port (
        r_w, en, enw, reset: in STD_LOGIC;
        aBus: in STD_LOGIC_VECTOR(7 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component program_counter is
    port (
        clk, en_A, ld, inc, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(7 downto 0);
        dBus: in STD_LOGIC_VECTOR(7 downto 0)
    );
end component;

component instruction_register is
    port (
        clk, en_A, en_D, ld, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        load, store, move, add, mul, jmp, bne, stop : out STD_LOGIC;
        areg, breg, treg : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

component regFile is
    port (
        clk, en_D, ld, selALU, reset: in STD_LOGIC;
        target, srcA, srcB, srcD: in STD_LOGIC_VECTOR(1 downto 0);
        ALUbusR: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        ALUbusA, ALUbusB: out STD_LOGIC_VECTOR(15 downto 0);
        r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15: out STD_LOGIC_VECTOR(7 downto 0)
    );
end component;

component alu is
    port (
        en_A, en_ram, enw_ram, ld: in STD_LOGIC_VECTOR;
        op: in STD_LOGIC_VECTOR(2 downto 0);
        rf_BusA, rf_BusB: in STD_LOGIC_VECTOR(7 downto 0);
        val: in STD_LOGIC_VECTOR(7 downto 0);
        reladd: in STD_LOGIC_VECTOR(4 downto 0);
        dBus: in STD_LOGIC_VECTOR(15 downto 0);
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        rf_BusR: out STD_LOGIC_VECTOR(7 downto 0);
    );
end component;

component controller
    port (
    	clk, reset:			in  STD_LOGIC;
    	mem_rw, mem_en, mem_enw: 		out STD_LOGIC;
    	pc_en_A, pc_ld, pc_inc: 		out STD_LOGIC;
    	ir_en_A, ir_en_D, ir_ld: 		out STD_LOGIC;
    	ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop:	in STD_LOGIC;
    	ir_treg, ir_areg, ir_breg: 		in STD_LOGIC_VECTOR(3 downto 0);
      rf_en_D, rf_ld, rf_selAlu: 	out STD_LOGIC;
      rf_target, rf_srcA, rf_srcB, rf_srcD: 		out STD_LOGIC_VECTOR(1 downto 0);
      alu_op: out STD_LOGIC_VECTOR(2 downto 0);
      alu_en_ram, alu_enw_ram   	: out STD_LOGIC;
      alu_val: out STD_LOGIC_VECTOR(7 downto 0);
      alu_reladd: STD_LOGIC_VECTOR(4 downto 0);
      alu_busR: STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

signal abus: STD_LOGIC_VECTOR(7 downto 0);
signal dbus: STD_LOGIC_VECTOR(7 downto 0);

signal mem_rw, mem_en, mem_enw: STD_LOGIC;

signal pc_en_A, pc_ld, pc_inc: STD_LOGIC;

signal ir_en_A, ir_en_D, ir_ld :  STD_LOGIC;
signal ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop : STD_LOGIC;
signal	ir_treg, ir_areg, ir_breg: 		STD_LOGIC_VECTOR(3 downto 0);

signal	rf_en_D, rf_ld, rf_selAlu:	STD_LOGIC;
signal	rf_target, rf_srcA, rf_srcB:	STD_LOGIC_VECTOR(1 downto 0);
signal	rf_srcD:			STD_LOGIC_VECTOR(1 downto 0);
signal	rf_busA, rf_busB:		STD_LOGIC_VECTOR(15 downto 0);

signal	alu_op:				STD_LOGIC_VECTOR(2 downto 0);
signal	alu_en_ram, alu_enw_ram:		STD_LOGIC;
signal alu_val:       STD_LOGIC_VECTOR(7 downto 0);
signal	alu_reladd:			STD_LOGIC_VECTOR(4 downto 0);
signal	alu_busR:			STD_LOGIC_VECTOR(15 downto 0);

begin

  pc : program_counter port map(clk, pc_en_A, pc_ld, pc_inc, reset, abus, dbus);

  ir : instruction_register port map(clk, ir_en_A, ir_en_D, ir_ld, reset, abus, dbus, ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop, ir_areg, ir_breg, ir_treg);

  rf : regFile port map(clk, rf_en_D, rf_ld, rf_selALU, reset, rf_target, rf_srcA, rf_srcB, rf_srcD, ALUbusR, dbus, rf_busA, rf_busB, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

  aluu : alu port map(en_A, alu_en_ram, alu_enw_ram, ld, alu_op, rf_BusA, rf_BusB, alu_val, alu_reladd, dbus, abus, alu_BusR);

  mem : ram port map(mem_rw, mem_en, mem_enw, reset, abus, dbus);

end topArch;
