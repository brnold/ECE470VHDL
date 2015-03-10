library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMValueGetter_SM is
	port(
	clk : in std_logic;
	clr : in std_logic;
		go: in std_logic;
		mux : out std_logic;
		val1reg, val2reg : out std_logic;
		done : out std_logic
		);
end RAMValueGetter_SM;

--}} End of automatically maintained section

architecture RAMValueGetter_SM of RAMValueGetter_SM is 
	
	type state_type is (start, S1, S2, S3); 
	
	signal present_state, next_state : state_type;
begin
	sreg: process(clk, clr)
	begin
		if clr = '1' then
			present_state <= start;
		elsif(clk'event and clk = '1' )then
			present_state <= next_state;
		end if;				   
	end process;
	
	C1: process(present_state, go) 
	begin
		case present_state is
			when start =>
				if go = '1' then
					next_state <= s1;
				else 
					next_state <= start;
				end if;

			when S1 =>
				next_state <= S2;				
			when S2 =>
				next_state <= S3;			
			when S3 =>
				next_state <= start;			
			
						
		end case;
			
	end process;
	
	C2 : process(present_state)
	begin
		mux <= '0';
		done <= '0';
		val1reg <= '0';
		val2reg <= '0';
		if present_state = s2 then
			mux <= '1';
			val1reg <= '1';
		elsif present_state = S3 then
			val2reg <= '1';
			done <='1';
		
		end if;
	end process;
	
	
end RAMValueGetter_SM;