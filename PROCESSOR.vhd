library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu is
	port(	clk:in std_logic; 
			load : in std_logic;
			outP:out std_logic_vector(7 downto 0)  
		);
end cpu; 
architecture Behavioral of cpu is  
component ram is   
	port(	clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);  
			addra : in std_logic_vector(7 downto 0);
			dina : in std_logic_vector(15 downto 0);    
			douta : out std_logic_vector(15 downto 0)     
		);
end component;  
component reg_File is
	port(	reset : in std_logic ;
			clk:in std_logic;
			we : in std_logic;
			addr :in std_logic_vector(3 downto 0);
			din:in std_logic_vector(7 downto 0);
			dout:out std_logic_vector(7 downto 0)
		);
end component;
signal pc: std_logic_vector(7 downto 0) := ( "00000000" ) ;
signal opcode: std_logic_vector(2 downto 0) := ( "000" ) ;
signal wea : std_logic_vector(0 downto 0) := "0";
signal addra : std_logic_vector(7 downto 0) := ( "00000000" );
signal dina : std_logic_vector(15 downto 0):= ( "0000000000000000" );    
signal douta : std_logic_vector(15 downto 0):= ( "0000000000000000" );  
signal we : std_logic := '0';
signal addr : std_logic_vector(3 downto 0):= ( "0000" );
signal din: std_logic_vector(7 downto 0):= ( "00000000" );
signal dout: std_logic_vector(7 downto 0):= ( "00000000" );
signal in_reg : std_logic_vector(15 downto 0):= ( "0000000000000000" );  
signal state : std_logic_vector(1 downto 0):=( "00" );
signal toDisp : std_logic;
signal inc : std_logic;
signal tempvar: std_logic_vector(15 downto 0):= ( "0000000000000000" );  

begin 

	
	  mem:ram port map(clk,wea,addra,dina,douta);
	registers:reg_File  port map(load,clk,we,addr,din,dout); 
	process(clk) 	
	variable s1, s2: std_logic_vector(7 downto 0):= ( "00000000" );
	begin
  	if clk'event and clk = '1' then 
	   if(toDisp='1') then
		addra <= "11111111"; 
		toDisp<='0' ;
		outP <= douta(7 downto 0);
		
		else	
		addra <= pc; 
		opcode <= douta(15 downto 13);
		in_reg <= douta; 
		if (load='1') then 
			pc <= ("00000000" ) ;
			state<="00";
			inc<='0';
		else 
		inc<='0' ;
		c1: case opcode is 
		when "000" => if(state = "00") then
						  we<= '0' ;
						  addr <= in_reg(8 downto 5);
						  addra <= dout ;
						  wea <= "0";
                    
					  s1 := douta(7 downto 0);
					  state<="11";
					  inc<='0';
					  else 
					  we <= '1';
					  din <= s1;
					  addr <= in_reg(12 downto 9);
					  state<="00";
					  inc<='1';
					  end if;
		when "001" => 
					if(state="00") then
							we <='0' ; 
			   	      addr<= in_reg(8 downto 5);	
							s1:=dout; 
		              state <="01";
							inc<='0' ;
					  else
					  we<='0' ; 
					  addr<= in_reg(12 downto 9) ; 
					  addra <= dout ;
					  wea <="1" ;
					  dina ( 7 downto 0) <= s1 ; 
					  inc<='1';
					  state<="00";
					  end if ;
		when "010" => we <= '1';
					  addr <= in_reg(12 downto 9);
					  din(7 downto 0) <= in_reg(8 downto 1);
					  inc<='1';
		when "011" =>
						if(state="00") then
					  we <= '0';
					  addr <= in_reg(8 downto 5);
					   s1 := dout;
					  state <="01";
					 inc<='0' ;
					  elsif(state="01") then
					  
					  we <= '0';
					  addr <= in_reg(4 downto 1);
					  s2 := dout + s1 ;
					  state <="11";
					 inc<='0' ;
					  else
					  
					  din <= s2;
					  we <= '1';
					  addr <= in_reg(12 downto 9);
					  inc<='1';
					  state<="00";
					  end if ;
		when "100" => if(state="00") then
					  we <= '0'; 
					  addr <= in_reg(8 downto 5); 
					  s1:=dout ; 
					  state <="01";
					 inc<='0' ;
					 
					  elsif(state="01") then				  
					  we <= '0'; 
					  addr <= in_reg(4 downto 1); 
					  s2 := dout; 
					  tempvar <= s1*s2; 
					  
					   state <="11";
					 inc<='0' ;
					 
					  else
					  s2 := tempvar(7 downto 0);  
					  we <= '1'; 
					  addr <= in_reg(12 downto 9); 
					  din <= s2; 					  					  
					  state<="00";
					  inc<='1' ;
					  end if ;
		when "101" => pc <= in_reg(12 downto 5);
					  inc<='0';
		when "110" => if(state="00") then
					  we <= '0';
					  addr <= in_reg(8 downto 5);
					  s1 := dout;
					  state <="01";
					 inc<='0' ;
					  elsif(state="01") then
					  
					  we <= '0';
					  addr <= in_reg(12 downto 9);
					  s2 := dout;
					  state <="11";
					 inc<='0' ;
					  else
						  if (s1 /= s2) then
							if(in_reg(4) = '0') then
							  pc <= pc + in_reg(3 downto 0);
							else 
							  pc <= pc - in_reg(3 downto 0);
							end if;
							inc<='0' ;
						  end if;
					  end if;
		when others =>  inc<='0' ;

		end case c1;
		
		if(inc ='1') then
		pc <= pc + 1;
		end if ;
		
		toDisp<='1' ;
		end if;
	end if;
	end if ;
	end process; 
end Behavioral;  

