library IEEE;
use IEEE.std_logic_1164.all;

entity instruction_register is
    port (
        clk, en_A, en_D, ld, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        load, store, move, add, mul, jmp, bne, stop : out STD_LOGIC;
        areg, breg, treg : out STD_LOGIC_VECTOR(3 downto 0)
    );
end instruction_register;

architecture irArch of instruction_register is
signal irReg: STD_LOGIC_VECTOR(15 downto 0);
begin
  process(clk) begin
  	if clk'event and clk = '0' then
  		if reset = '1' then
  			irReg <= x"0000";
  		elsif ld = '1' then
  			irReg <= dBus;
  		end if;
  	end if;
  end process;

  aBus <= "000000" & irReg(9 downto 0) when en_A = '1' else
  	  "ZZZZZZZZZZZZZZZZ";
  dBus <= "000000" & irReg(9 downto 0) when en_D = '1' else
  	  "ZZZZZZZZZZZZZZZZ";

  load    <= '1' when irReg(15 downto 13) = "000" 	else '0';
  store   <= '1' when irReg(15 downto 13) = "001" 	else '0';
  move    <= '1' when irReg(15 downto 13) = "010" 	else '0';
  add     <= '1' when irReg(15 downto 13) = "011" 	else '0';
  mul     <= '1' when irReg(15 downto 13) = "100" 	else '0';
  jmp     <= '1' when irReg(15 downto 13) = "101" 	else '0';
  bne  	  <= '1' when irReg(15 downto 13) = "110" 	else '0';
  stop    <= '1' when irReg(15 downto 13) = "111" 	else '0';

  treg	  <= irReg(12 downto 9) when (not irReg(15 downto 13) = "111") else
             "0000";
  areg	  <= irReg( 8 downto  5) when (not irReg(15 downto 13) = "101") else
             "0000";
  breg	  <= irReg( 4 downto  1) when (irReg(15 downto 13) = "011" or irReg(15 downto 13) = "100" or irReg(15 downto 13) = "110") else
             "0000";


end irArch;
