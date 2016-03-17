library IEEE;
use IEEE.std_logic_1164.all;

entity controller is
  port (
    clk, reset:			in  STD_LOGIC;
    mem_en, mem_enw: 		out STD_LOGIC;
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
end controller;

architecture controllerArch of controller is
type state_type is (
      reset_state,
			fetch0, fetch1, fetch2,
			load0, load1,
			store0, store1,
			move0, move1,
			add0, add1,
			mul0, mul1,
			jmp0, jmp1,
			bne0, bne1, bne2,
			stop
			);
signal state: state_type;

begin

  process(clk) begin
  	if clk'event and clk = '1' then
  		if reset = '1' then state <= reset_state;
  		else
  			case state is
  			when reset_state => state <= fetch0;
  			when fetch0 => state <= fetch1;
    		when fetch1 =>
    			if ir_load = '1' then state <= load0;
    			elsif ir_store = '1' then state <= store0;
    			elsif ir_move = '1' then state <= move0;
    			elsif ir_add = '1' then state <= add0;
    			elsif ir_mul = '1' then state <= mul0;
    			elsif ir_jmp = '1' then state <= jmp0;
    			elsif ir_bne = '1' then state <= bne0;
    			elsif ir_stop = '1' then state <= stop0;
    			end if;

        when load0 => 	state <= load1;
        when load1 => 	state <= fetch0;

        when store0 => 	state <= store1;
        when store1 => 	state <= fetch0;

        when move0 => 	state <= move1;
        when move1 => 	state <= fetch0;

        when add0 => 	state <= add1;
        when add1 => 	state <= add0;

        when mul0 => 	state <= mul1;
        when mul1 => 	state <= fetch0;

        when jmp0 => 	state <= jmp1;
        when jmp1 => 	state <= fetch0;

        when bne0 => 	state <= bne1;
        when bne2 => 	state <= bne2;
        when bne2 => 	state <= fetch0;

        when others => 	state <= stop;

        end case;
  		end if;
  	end if;
  end process;

  process(clk) begin -- special process for memory write timing
  	if clk'event and clk = '0' then
  		if (state = store0) or
  		    state = store2 then
  			mem_rw <= '0';
  		else
  			mem_rw <= '1';
  		end if;
  	end if;
  end process;


  mem_en <= '1' when state = load1  else '0';

  mem_enw <= '1' when state = store1  else '0';

  pc_en_A <= '1' when state = fetch0 or state = fetch1 or state = fetch2 or state = bne0  else '0';

  pc_ld <= '1' when state = jmp1 or state = bne2  else '0';

  pc_inc <= '1' when state = fetch1  else '0';

  ir_en_A <= '1' when state = load0 or state = load1 or state = store0 or state = store1   else '0';

  ir_en_D <= '1' when state = load0 or state = load1  else '0';

  ir_ld <= '1' when state = fetch2  else '0';

  rf_en_D <= '1' when   else '0';

  rf_ld <= '1' when   else '0';

  rf_selAlu <= '1' when   else '0';

  alu_en_ram <= '1' when state = load1  else '0';

  alu_enw_ram <= '1' when state = store1  else '0';

  rf_target <= ir_treg;
  rf_srcA <= ir_areg;
  rf_srcB <= ir_breg;
  rf_srcD <= ir_treg;


  alu_op <= 	"000"   when state = load0 or state = load1 else
  	    	    "001"   when state = store0 or state = store1 else
  	 	        "010"   when state = move0 or state =  move1 else
  		        "011"   when state = add0 or state = add1 else
  	 	        "100"   when state = mul0 or state = mul1 else
  	  	      "101"   when state = jmp0 or state = jmp1 else
              "110"   when state = bne0 or state = bne1 else
  	    	"000";


end controllerArch;
