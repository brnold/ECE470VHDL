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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity SPI_Slave is
	 port(
		 sclk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 dataIn : in STD_LOGIC;
		 sslect : in STD_LOGIC;
		 ready : out STD_LOGIC;
		 dataOut : out STD_LOGIC_VECTOR(7 downto 0)
	     );
end SPI_Slave;

architecture SPI_Slave of SPI_Slave is 
signal shifty : STD_logic_vector(7 downto 0);
signal counter : unsigned(2 downto 0);
begin

	SPI : process(sclk, reset, shifty)
	begin 
		if(reset = '1') then
			counter <= "000";
			dataOut <= "00000000";
			shifty <= "00000000";
			
		elsif sclk'event and sclk = '1' then
		  
		  -- Count up and shift in data while slave select is active
		  if sslect = '0' then
		    counter <= counter + 1;
		    shifty <= shifty (6 downto 0) & dataIn;
      	  end if;
      
      	-- Latch output when all done shifting
      	if (counter = "111") then
        	ready <= '1'; 
        	dataOut <= shifty;
      	else
        	ready <= '0';
      	end if;
		
		  end if;
	end process SPI;
	
end SPI_Slave;
