library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;

use IEEE.NUMERIC_STD.ALL;

entity reg_File is
	port(	reset : in std_logic ;
			clk:in std_logic;
			we : in std_logic;
			addr :in std_logic_vector(3 downto 0);
			din:in std_logic_vector(7 downto 0);
			dout:out std_logic_vector(7 downto 0)
		);
end reg_File;

architecture Behavioral of reg_File is
type regFile_array is array (0 to 15) of std_logic_vector(7 downto 0);
signal reg_array : regFile_array;
begin
	 process(clk) begin
  	if clk'event and clk = '1' then
	
		if reset = '1' then
  			for i in 0 to 15 loop
  				reg_array(i) <= "00000000";
  			end loop;
			elsif(we = '0') then
			dout <= reg_array(conv_integer(IEEE.STD_LOGIC_arith.unsigned(addr))) ;
				
			else
				reg_array(conv_integer(IEEE.STD_LOGIC_arith.unsigned(addr))) <= din ;
				dout <= din ;
			end if;
		end if;
	end process;
end Behavioral;

