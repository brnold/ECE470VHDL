-------------------------------------------------------------------------------
--
-- Title       : Memory_Controller
-- Design      : ECE470
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\ECE470\ECE470\ECE470\src\Memory_Controller.vhd
-- Generated   : Sat Mar  7 15:42:31 2015
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Memory_Controller} architecture {Memory_Controller}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;

entity Memory_Controller is
	 port(
		 ready : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 dataSPIIn : in STD_LOGIC_VECTOR(7 downto 0);
		 addr : out STD_LOGIC_VECTOR(15 downto 0);
		 dataOut : out STD_LOGIC_VECTOR(7 downto 0)
	     );
end Memory_Controller;

--}} End of automatically maintained section

architecture Memory_Controller of Memory_Controller is
signal counter : std_logic_vector(15 downto 0);
begin
	process(reset)
	begin
		if(reset = '1')	 then
			addr <= "0000000000000000";
			data <= "00000000"; 
		end if;
	end process;
	
	process(ready)
	begin
		if(ready = '1')	then
			counter <= counter + 1;
		end if;
	end process;

end Memory_Controller;
