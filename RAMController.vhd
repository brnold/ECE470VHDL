library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RAMController is
	port(
		clk : in std_logic;
		clr : in std_logic;
		SPIFlag : in std_logic;
		dataIn : in std_logic_vector(7 downto 0);
		dataOut : out std_logic_vector(7 downto 0);
		memAddr : out std_logic_vector(14 downto 0);
		newData : in std_logic;
		RAMLoad : out std_logic
		);
end RAMController;

--}} End of automatically maintained section

architecture RAMController of RAMController is 
	
	type state_type is (start,  loadEntireScreen, resetState); 
	signal present_state, next_state : state_type; 
	signal  lRegS, incAddrS, clrAccS : std_logic;
	signal regOutS : std_logic_vector(7 downto 0);
	signal memAddrS : std_logic_vector(14 downto 0);
	constant LOADWHOLESCREEN : std_logic_vector (7 downto 0) := "00000001";
	constant RESETCODE : std_logic_vector(7 downto 0) := "00000101";
begin
	sreg: process(clk, clr, SPIFlag)
	begin
		if clr = '1'  then
			present_state <= start;
		elsif(clk'event and clk = '1' )then
			present_state <= next_state;
		end if;				   
	end process;
	
	C1: process(present_state, SPIFlag, newData, memAddrS) 
	begin
		case present_state is
			when start =>
				if SPIFlag = '0' then
					next_state <= loadEntireScreen;
				else 
					next_state <= start;
				end if;
				
			--when newCommand =>
--				if regOutS = LOADWHOLESCREEN then 
--					next_state <= loadEntireScreen;
--				elsif regOutS = RESETCODE then
--					next_state <= resetState;
--				end if;
				
			when loadEntireScreen =>
				if memAddrS = "0111010100110000" then --150*200 = 30,000
					next_state <= start;
				
				else
					next_state <= loadEntireScreen;
				end if;
			when resetState =>			--#fix
				next_state <= start;
		end case;		
	end process;
	
	C2 : process(present_state, newData)
	begin
		lRegS <= '0';
		RAMLoad <= '0';	--put the RAM high
		incAddrS <= '0'; 
		clrAccS <= '0';
		if present_state = start then
			lRegS <= '1';
			clrAccS <= '1';
		elsif present_state = loadEntireScreen then
			if newData = '1' then  --if we have the new data
				lRegS <= '1'; --load the new data to the memory
				RAMLoad <= '1';	--put the RAM high
				incAddrS <= '1';
			end if;	
		elsif present_state = resetState then
			clrAccS <= '1';
		end if;
	end process;  
	
	registers : process(clk, dataIn, clr, lRegS)
	begin
		if clr = '1' then
			regOutS <= "00000000"; --might need to specify which bits
		elsif(clk'event and clk = '1' and lRegS = '1') then
			regOutS <= dataIn; --might need to specify which bits
		end if;
	end process;
	
	
	accumulator: process(incAddrS, clrAccS, clr, clk) 
	begin
		if(clrAccS = '1' or clr = '1')  then
			memAddrS <= "000000000000000"; 
		elsif(incAddrS = '1' and clk'event and clk = '1') then
			memAddrS <= memAddrS + 1;
		end if;
	end process;
	
	memAddr <= memAddrS;
	dataOut <= regOuts;
	
end RAMController;