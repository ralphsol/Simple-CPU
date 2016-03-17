library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-- use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        en_A, en_ram, enw_ram, ld: in STD_LOGIC;
        op: in STD_LOGIC_VECTOR(2 downto 0);
        rf_BusA, rf_BusB: in STD_LOGIC_VECTOR(7 downto 0);
        val: in STD_LOGIC_VECTOR(7 downto 0);
        reladd: in STD_LOGIC_VECTOR(4 downto 0);
        dBus: in STD_LOGIC_VECTOR(15 downto 0);
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        rf_BusR: out STD_LOGIC_VECTOR(7 downto 0);
    );
end alu;

architecture aluArch of alu is
signal zeros: STD_LOGIC_VECTOR(7 downto 0);
begin

zeros <= "00000000";
  process()
  variable p: STD_LOGIC_VECTOR(15 downto 0)
  variable N,S : STD_LOGIC_VECTOR(7 downto 0) => "00000000";
  variable i : STD_LOGIC_VECTOR;
    begin
    if (op = "000") then  -- Load
        aBus <= rf_BusA;
        en_ram <= '1';
        rf_busB <= dBus;

    elsif (op = "001") then -- Store
        aBus <= rf_BusA;
        enw_ram <= '1';
        dBus <= rf_BusB;

    elsif (op = "010") then -- Move
        rf_BusR <= val;

    elsif (op = "011") then -- Add
        rf_BusR <= unsigned(rf_BusA) + unsigned(rf_BusB);

    elsif (op = "100") then -- Multiply
        rf_BusR <= zeros;
        for i in 0 to 7 loop
            if (rf_BusA(i)='1')
              N <= rf_BusA(7-i downto 0) & zeros(i-1 downto 0);
            else
              N <= "00000000";
            end if;
          rf_BusR <= rf_BusR + N;
        end loop;

    elsif (op = "101") then -- Jump
        p <= val;
        ld <= '1';
        dBus <= p;

    elsif (op = "110") then -- bne
        en_A <= '1';
        p <= aBus;
        if not(rf_BusA - rf_BusB = "00000000") then
          p <= p + ("000" & reladd);
        end if;
        ld <= '1';
        dBus <= p;


    else                    -- STOP

  end process


end aluArch;
