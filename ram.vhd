library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ram is
    port (
        r_w, en, enw, reset: in STD_LOGIC;
        aBus: in STD_LOGIC_VECTOR(7 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0)
    );
end ram;

architecture ramArch of ram is
type ram_typ is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ram: ram_typ;
begin
  process(reset, r_w)
  variable i: integer;
   begin
  	if reset = '1' then
  		for i in 0 to 255 loop
        ram(i): <= "0000000000000000";
      end loop
  	elsif r_w'event and r_w = '0' then
  		ram(conv_integer(unsigned(aBus))) <= dBus;
  	end if;
  end process;
  ram(conv_integer(unsigned(aBus))) <= dBus when reset = '0' and enw = '1' and r_w = '1' ;
  dBus <= ram(conv_integer(unsigned(aBus)))(7 downto 0)	when reset = '0' and en = '1' and r_w = '1' else
	  "ZZZZZZZZZZZZZZZZ";
end ramArch;
