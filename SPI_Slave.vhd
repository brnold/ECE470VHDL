-------------------------------------------------------------------------------
--
-- Title       : SPI_Slave
-- Design      : ECE470
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\ECE470\ECE470\ECE470\src\SPI_Slave.vhd
-- Generated   : Sat Mar  7 13:42:39 2015
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
--{entity {SPI_Slave} architecture {SPI_Slave}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;

entity SPI_Slave is
	 port(
		 sclk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 dataIn : in STD_LOGIC;
		 sslect : in STD_LOGIC;
		 ready : out STD_LOGIC;
		 resetOut : out STD_LOGIC;
		 dataOut : out STD_LOGIC_VECTOR(7 downto 0)
	     );
end SPI_Slave;

--}} End of automatically maintained section

architecture SPI_Slave of SPI_Slave is 
signal shifty : STD_logic_vector(7 downto 0);
signal counter : std_logic_vector(2 downto 0);
begin

	--SPI process
	process(sclk, reset, sslect)
	begin 
		if(reset = '1') then
			shifty(7 downto 0) <= "00000000";
		elsif sslect = '1' and sclk'event and sclk = '1' then  --If we are good to load, and we have a high clock 
			shifty(6 downto 0) <= shifty (7 downto 1);
			shifty(7) <= dataIn;
		end if;
	end process;
	
	
	--ready process
	process(sclk, reset, sslect)
	begin 
		if(reset = '1') then
			counter <= "000";
			dataOut <= "00000000";
		elsif sslect = '1' and sclk'event and sclk = '1' then 
			counter <= counter + 1;
		end if;
		
		if (counter = "111") then
			ready <= '1'; 
			dataOut <= shifty;
		else
			ready <= '0';
		end if;
		
	end process;
	
	resetOut <= '0' --#fix, need to add that the SPI master can "reset" the VGA controller.


end SPI_Slave;
