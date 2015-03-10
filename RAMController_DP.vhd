library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RAMValueGetter_DP is
	port(	
	clk : in std_logic;
		clr : in std_logic;
		incAcc : in std_logic;
		clrAcc : in std_logic;
		startFlag : out std_logic;
		resetFlag : out std_logic;
		load : in std_logic;
		dataIn : in std_logic_vector(7 downto 0);
		bigNumber : out std_logic;
		memAddr : out std_logic_vector(15 downto 0)
	     );
end RAMValueGetter_DP;

--}} End of automatically maintained section

--Constants
constant LOADWHOLESCREEN : std_logic_vector(7 downto 0):= "00000001";
constant RESETCODE : std_logic_vector(7 downto 0):= "00000101";

architecture RAMValueGetter_DP of RAMValueGetter_DP is 
signal regOutS : std_logic_vector( 7 downto 0);
signal memAddrS : std_logic_vector(15 downto 0);
 
begin
	
	
	--register for holding the data in
	registers : process(clk, dataIn, clr)
	begin
		if clr = '1' then
			regOut <= "00000000"; --might need to specify which bits
		elsif(clk'event and clk = '1' and load = '1') then
			regOut <= dataIn; --might need to specify which bits
		end if;
	end process;
	
	process(regOutS)
	begin
		startFlag <= '0';
		resetFlag <= '1';
		
		if regOutS = LOADWHOLESCREEN then
			startFlag <= '1';
		elsif regOutS = RESETCODE then
			resetFlag <= '1';
		end if;	
		
	end process;
	
	
	process(incAccFlag) 
	begin
		if(clrAcc = '1')
			memAddrS <= "0000000000000000"; --I reallllllly should figureout how to represent hex in VHDL...
		elsif(incAcc = '1' and clk'event and clk = '1') then
			memAddrS = memAddrS + 1;
		end if;
	end process;
	
	
	--tiding up section
	dataOut <= regOutS;
	memAddr <= memAddrS;
	
end RAMValueGetter_DP;