library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ECE470_top is
	port(
	clk : in std_logic;
	JB : in std_logic_vector(2 downto 0);
	JC : out std_logic_vector(0 downto 0);
	btnR : in std_logic;
	led : out std_logic_vector(14 downto 0);
	btnD : in std_logic;
	hsync, vsync : out std_logic;
	vgaRED, vgaGreen, vgaBLue : out std_logic_vector( 3 downto 0)
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


		
		-- Component declaration of the "vga_800x600(behavioral)" unit defined in
	-- file: "./../src/vga800x600.vhd"
	component vga_800x600
	port(
		clk : in STD_LOGIC;
		hsync : out STD_LOGIC;
		vsync : out STD_LOGIC;
		hc : out STD_LOGIC_VECTOR(10 downto 0);
		vc : out STD_LOGIC_VECTOR(10 downto 0);
		vidon : out STD_LOGIC);
	end component;
	for all: vga_800x600 use entity work.vga_800x600(behavioral);
	
			-- Component declaration of the "clock(xilinx)" unit defined in
	-- file: "./../src/clock.vhd"
	component clock
	port(
		CLK_IN1 : in STD_LOGIC;
		CLK_OUT1 : out STD_LOGIC;
		RESET : in STD_LOGIC;
		LOCKED : out STD_LOGIC);
	end component;
	for all: clock use entity work.clock(xilinx);  
		
			-- Component declaration of the "VGA_Display(vga_display)" unit defined in
	-- file: "./../src/vga_dispalyer.vhd"
	component VGA_Display
	port(
		vidon : in STD_LOGIC;
		hc : in STD_LOGIC_VECTOR(10 downto 0);
		vc : in STD_LOGIC_VECTOR(10 downto 0);
		RAMin : in STD_LOGIC_VECTOR(7 downto 0);
		RAMaddr : out STD_LOGIC_VECTOR(14 downto 0);
		red : out STD_LOGIC_VECTOR(3 downto 0);
		green : out STD_LOGIC_VECTOR(3 downto 0);
		blue : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	for all: VGA_Display use entity work.VGA_Display(vga_display);


 
 signal weaS, peskyThing	: std_logic_vector(0 downto 0);
 signal readys, clk40, vidons : std_logic;
 signal memAddrS, RAMaddrs : std_logic_vector(14 downto 0); 
 signal dataMem2RAMS, dataSPI2ControllerS, RAMin, dinb : std_logic_vector(7 downto 0);
 signal hcs, vcs : std_logic_vector(10 downto 0);  
 --signal leds : std_logic_vector(7 downto 0);
begin

	SPI_interface : SPI_Slave
	port map(
		sclk => JB(1),
		reset => btnR,
		dataIn => jb(2),
		sslect => jb(0),
		ready => readys,
		dataOut => dataSPI2ControllerS
	); 
	
	led <= memAddrS;
	
	RAMController_component : RAMController
	port map(
		clk => Jb(1),
		clr =>  btnR,
		SPIFlag => jb(0),
		dataIn => dataSPI2ControllerS,
		dataOut => dataMem2RAMS,
		memAddr => memAddrS,
		newData => readys,
		RAMLoad => weaS(0)
	); 
	
	DP_RAM_component : DP_RAM_150x200
	port map(
		clka => Jb(1),
		wea => weaS,
		addra => memAddrS,
		dina => dataMem2RAMS,
		douta => open,
		clkb => clk40,
		web => peskyThing,
		addrb => RAMaddrs,
		dinb => dinb,
		doutb => RAMin
	);
	
	peskyThing(0) <= '0';
	dinb <= "00000000";
	
	vga_controll : vga_800x600
	port map(
		clk => clk40,
		hsync => hsync,
		vsync => vsync,
		hc => hcs,
		vc => vcs,
		vidon => vidons
	); 
	
	clocky : clock
	port map(
		CLK_IN1 => clk,
		CLK_OUT1 => clk40,
		RESET => btnR,
		LOCKED => open
	);
	
	ColorGetterThingy : VGA_Display
	port map(
		vidon => vidons,
		hc => hcs,
		vc => vcs,
		RAMin => RAMin,
		RAMaddr => RAMaddrs,
		red => vgared,
		green => vgagreen,
		blue => vgablue
	); 
	
	Jc(0) <= btnD;

end ECE470_top;
