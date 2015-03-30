-- Example 6a: vga_ScreenSaver
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE ieee.numeric_std.ALL;

entity VGA_Display is
	port ( 
		vidon: in std_logic;
		hc : in std_logic_vector(10 downto 0);
		vc : in std_logic_vector(10 downto 0);
		RAMin : in std_logic_vector(7 downto 0);
		RAMaddr : out std_logic_vector(14 downto 0);	
	   	red : out std_logic_vector(3 downto 0);
		green : out std_logic_vector(3 downto 0);
		blue : out std_logic_vector(3 downto 0)
		);
end VGA_Display;

architecture VGA_Display of VGA_Display is 
	signal hcd4, vcd4 : std_logic_vector(7 downto 0);	--divded by 64 signal

	
	
	signal inthcd8, intvcd8, spriteNum : integer;
	
	constant w: integer := 800;
	constant h: integer := 600;	 
	constant C1: integer := 0; 
	constant R1: integer := 0;		
	signal spriteon, m: std_logic;
begin 
	

	  
	hcd4	<= hc(9 downto 2); --divded by 4
	vcd4	<= vc(9 downto 2); --divded by 4 --i want vcd *600
	
	

	
	RAMaddr <= hcd4 + ( vcd4 & "0") + ( vcd4 & "00") + ( vcd4 & "0000") + ( vcd4 & "0000000");
	--
--	process(hc, vc)
--	begin			
--		if(hc < 200 and vc < 150) then
--			RAMaddr <= hc(7 downto 0) + ( vc(7 downto 0) & "0") + ( vc(7 downto 0) & "00") + ( vc(7 downto 0) & "0000") + ( vc(7 downto 0) & "0000000");
--		else
--			RAMaddr <= (others => '0');
--		end if;
--		
--		
--	end process;
	
	
	spriteon <= '1' when (((hc > C1) and (hc <= C1 + w)) --Sprite on figureouter
	and ((vc >= R1 ) and (vc < R1 + h))) else '0'; 
	
	
	
	process(spriteon, vidon, RAMin)
		variable j: integer;
	begin
		red <= "0000";
		green <= "0000";
		blue <= "0000";
		if spriteon = '1' and vidon = '1' then
				red <= RAMin(7 downto 5) & '0';
				green <= RAMin(4 downto 2) & '0';
				blue <= RAMin(1 downto 0)&"00"; 
			
		end if;
	end process; 
	
end VGA_Display;