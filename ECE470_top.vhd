-------------------------------------------------------------------------------
--
-- Title       : ECE470_top
-- Design      : ECE470
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\ECE470\ECE470\ECE470\src\ECE470_top.vhd
-- Generated   : Wed Mar 11 20:31:22 2015
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
--{entity {ECE470_top} architecture {ECE470_top}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ECE470_top is
	port(
	SPIClk : in std_logic;
	mclk : in std_logic;
	JA : in std_logic_vector(2 downto 0);
	btn : in std_logic_vector(0 downto 0)
	 );
end ECE470_top;



architecture ECE470_top of ECE470_top is
  			-- Component declaration of the "SPI_Slave(spi_slave)" unit defined in
	-- file: "./../src/SPI_Slave.vhd"
	component SPI_Slave
	port(
		sclk : in STD_LOGIC;
		reset : in STD_LOGIC;
		dataIn : in STD_LOGIC;
		sslect : in STD_LOGIC;
		ready : out STD_LOGIC;
		dataOut : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	for all: SPI_Slave use entity work.SPI_Slave(spi_slave); 
		
			-- Component declaration of the "RAMController(ramcontroller)" unit defined in
	-- file: "./../src/RAMController.vhd"
	component RAMController
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		SPIFlag : in STD_LOGIC;
		dataIn : in STD_LOGIC_VECTOR(7 downto 0);
		dataOut : out STD_LOGIC_VECTOR(7 downto 0);
		memAddr : out STD_LOGIC_VECTOR(14 downto 0);
		newData : in STD_LOGIC;
		RAMLoad : out STD_LOGIC);
	end component;
	for all: RAMController use entity work.RAMController(ramcontroller);

		-- Component declaration of the "DP_RAM_150x200(dp_ram_150x200_a)" unit defined in
	-- file: "./../src/DP_RAM_150x200.vhd"
	component DP_RAM_150x200
	port(
		clka : in STD_LOGIC;
		wea : in STD_LOGIC_VECTOR(0 downto 0);
		addra : in STD_LOGIC_VECTOR(14 downto 0);
		dina : in STD_LOGIC_VECTOR(7 downto 0);
		douta : out STD_LOGIC_VECTOR(7 downto 0);
		clkb : in STD_LOGIC;
		web : in STD_LOGIC_VECTOR(0 downto 0);
		addrb : in STD_LOGIC_VECTOR(14 downto 0);
		dinb : in STD_LOGIC_VECTOR(7 downto 0);
		doutb : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	for all: DP_RAM_150x200 use entity work.DP_RAM_150x200(dp_ram_150x200_a);
 
 signal weaS	: std_logic_vector(0 downto 0);
 signal readys : std_logic;
 signal memAddrS : std_logic_vector(14 downto 0); 
 signal dataMem2RAMS, dataSPI2ControllerS : std_logic_vector(7 downto 0);
begin

	SPI_interface : SPI_Slave
	port map(
		sclk => JA(0),
		reset => btn(0),
		dataIn => ja(2),
		sslect => ja(1),
		ready => readys,
		dataOut => dataSPI2ControllerS
	); 
	
	RAMController_component : RAMController
	port map(
		clk => JA(0),
		clr =>  btn(0),
		SPIFlag => ja(1),
		dataIn => dataSPI2ControllerS,
		dataOut => dataMem2RAMS,
		memAddr => memAddrS,
		newData => readys,
		RAMLoad => weaS(0)
	); 
	
	DP_RAM_150x200_component : DP_RAM_150x200
	port map(
		clka => JA(0),
		wea => weaS,
		addra => memAddrS,
		dina => dataMem2RAMS,
		douta => open,
		clkb => mclk,
		web => web,
		addrb => addrb,
		dinb => dinb,
		doutb => doutb
	);

end ECE470_top;
