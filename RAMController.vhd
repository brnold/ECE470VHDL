
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMValueGetter is
	 port(
		clk : in std_logic; 
		clr : in std_logic;
		 go  : in std_logic;
		CursorLoc : in std_logic_vector(6 downto 0);
		RAM_data : in STD_LOGIC_VECTOR(2 downto 0);
		keyflag : in std_logic_vector(2 downto 0);
		 RAM_addr : out STD_LOGIC_VECTOR(6 downto 0);
		 loc1 : out STD_LOGIC_VECTOR(6 downto 0); 
		 loc2 : out STD_LOGIC_VECTOR(6 downto 0);
		 shape_peg_1 : out std_logic_vector(2 downto 0);
		 shape_peg_2 : out std_logic_vector(2 downto 0); 
		 done : out std_logic
	     );
end RAMValueGetter;

--}} End of automatically maintained section

architecture RAMValueGetter of RAMValueGetter is
	 	-- Component declaration of the "RAMLocationCalculator(ramlocationcalculator)" unit defined in
	-- file: "./../src/RAMLocationCalculator.vhd"
	component RAMLocationCalculator
	port(
		CursorLoc : in STD_LOGIC_VECTOR(6 downto 0);
		keyflag : in STD_LOGIC_VECTOR(2 downto 0);
		PEG_1 : out STD_LOGIC_VECTOR(6 downto 0);
		PEG_2 : out STD_LOGIC_VECTOR(6 downto 0));
	end component;
	for all: RAMLocationCalculator use entity work.RAMLocationCalculator(ramlocationcalculator);
   
			-- Component declaration of the "RAMValueGetter_DP(ramvaluegetter_dp)" unit defined in
	-- file: "./../src/RAMValueGetter_DP.vhd"
	component RAMValueGetter_DP
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		RAM_data : in STD_LOGIC_VECTOR(2 downto 0);
		RAM_addr : out STD_LOGIC_VECTOR(6 downto 0);
		loc1 : in STD_LOGIC_VECTOR(6 downto 0);
		loc2 : in STD_LOGIC_VECTOR(6 downto 0);
		value1 : out STD_LOGIC_VECTOR(2 downto 0);
		value2 : out STD_LOGIC_VECTOR(2 downto 0);
		mux : in STD_LOGIC;
		val1reg : in STD_LOGIC;
		val2reg : in STD_LOGIC);
	end component;
	for all: RAMValueGetter_DP use entity work.RAMValueGetter_DP(ramvaluegetter_dp);
		
			-- Component declaration of the "RAMValueGetter_SM(ramvaluegetter_sm)" unit defined in
	-- file: "./../src/RAMValueGetter_SM.vhd"
	component RAMValueGetter_SM
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		go : in STD_LOGIC;
		mux : out STD_LOGIC;
		val1reg : out STD_LOGIC;
		val2reg : out STD_LOGIC;
		done : out STD_LOGIC);
	end component;
	for all: RAMValueGetter_SM use entity work.RAMValueGetter_SM(ramvaluegetter_sm);
	  
		signal loc1s, loc2s	: STD_LOGIC_VECTOR(6 downto 0);	
		signal mux, val1reg, val2reg : std_logic;
begin  
	
	 RVDP : RAMValueGetter_DP
	port map(
		clk => clk,
		clr => clr,
		RAM_data => RAM_data,
		RAM_addr => RAM_addr,
		loc1 => loc1s,
		loc2 => loc2s,
		value1 => shape_peg_1,
		value2 => shape_peg_2,
		mux => mux,
		val1reg => val1reg,
		val2reg => val2reg
	);
	
	RVSM : RAMValueGetter_SM
	port map(
		clk => clk,
		clr => clr,
		go => go,
		mux => mux,
		val1reg => val1reg,
		val2reg => val2reg,
		done => done
	);
	
	RLC : RAMLocationCalculator
	port map(
		CursorLoc => CursorLoc,
		keyflag => keyflag,
		PEG_1 => loc1s,
		PEG_2 => loc2s
	);
	
	loc1 <= loc1s; 
	loc2 <= loc2s;
	
end RAMValueGetter;
