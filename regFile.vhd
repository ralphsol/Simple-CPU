library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity regFile is
    port (
        clk, en_D, ld, selALU, reset: in STD_LOGIC;
        target, srcA, srcB, srcD: in STD_LOGIC_VECTOR(1 downto 0);
        ALUbusR: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        ALUbusA, ALUbusB: out STD_LOGIC_VECTOR(15 downto 0);
        r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15: out STD_LOGIC_VECTOR(7 downto 0)
    );
end regFile;

architecture regFileArch of regFile is
type regFile_typ is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
signal reg: regFile_typ;
begin
  process(clk) begin
  	if clk'event and clk = '1' then
  		if reset = '1' then
  			for i in 0 to 15 loop
  				reg(i) <= "00000000";
  			end loop;
  		elsif ld = '1' and selALU = '1' then
  			reg(conv_integer(unsigned(target))) <= ALUbusR;
  		elsif ld = '1' and selALU = '0' then
  			reg(conv_integer(unsigned(target))) <= dBus;
  		end if;
  	end if;
  end process;
  dBus <= reg(conv_integer(unsigned(srcD))) when en_D = '1' else
  	  "ZZZZZZZZZZZZZZZZ";
  ALUbusA <= reg(conv_integer(unsigned(srcA)));
  ALUbusB <= reg(conv_integer(unsigned(srcB)));
  r0 <= reg(0);
  r1 <= reg(1);
  r2 <= reg(2);
  r3 <= reg(3);
  r4 <= reg(4);
  r5 <= reg(5);
  r6 <= reg(6);
  r7 <= reg(7);
  r8 <= reg(8);
  r9 <= reg(9);
  r10 <= reg(10);
  r11 <= reg(11);
  r12 <= reg(12);
  r13 <= reg(13);
  r14 <= reg(14);
  r15 <= reg(15);
end regFileArch;
