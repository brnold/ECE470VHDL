library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity vga_800x600 is
  port (
    clk    : in  std_logic;
    hsync  : out std_logic;
    vsync  : out std_logic;
    hc     : out std_logic_vector(10 downto 0);
    vc     : out std_logic_vector(10 downto 0);
    --in_vbp : out std_logic;
    vidon  : out std_logic
    );
end vga_800x600;

architecture Behavioral of vga_800x600 is
                                        --spec from
                                        --http://tinyvga.com/vga-timing/1024x768@60Hz
                                        --horizontal timing
  constant h_visible_area : integer := 800;
  constant h_front_porch  : integer := 40;
  constant h_sync_pulse   : integer := 128;
  constant h_back_porch   : integer := 88;
  constant h_whole_line   : integer := h_visible_area + h_front_porch + h_sync_pulse + h_back_porch;
  constant h_front_offset : integer := h_back_porch + h_sync_pulse;
  constant h_back_offset  : integer := h_whole_line - h_front_porch;

                                        --vertical timing
  constant v_visible_area : integer := 600;
  constant v_front_porch  : integer := 1;
  constant v_sync_pulse   : integer := 4;
  constant v_back_porch   : integer := 23;
  constant v_whole_line   : integer := v_visible_area + v_front_porch + v_sync_pulse + v_back_porch;
  constant v_front_offset : integer := v_back_porch + v_sync_pulse;
  constant v_back_offset  : integer := v_whole_line - v_front_porch;

                                        --horizontal and vertical counters
  signal hcs : std_logic_vector(10 downto 0) := (others => '0');
  signal vcs : std_logic_vector(10 downto 0) := (others => '0');
  
 

begin
                                        --Counter for the horizontal sync signal
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if hcs = h_whole_line - 1 then
                                        --The counter has reached the end of pixel count
        hcs <= "00000000000";           --reset the counter
      else
        hcs <= hcs + 1;                 --Increment the horizontal counter
      end if;
    end if;
  end process;

--Counter for the vertical sync signal
  process(clk)
  begin
    if clk'event and clk = '1' then
      if hcs = h_whole_line - 1 then
                                        --Increment when enabled
        if vcs = v_whole_line - 1 then
                                        --Reset when the number of lines is reached
          vcs <= "00000000000";
        else
          vcs <= vcs + 1;               --Increment vertical counter
        end if;
      end if;
    end if;
  end process;

  --in_vbp <= '1' when vcs < v_back_porch else '0';

                                        --sync pulses
  hsync <= '0' when hcs < h_sync_pulse else '1';
  vsync <= '0' when vcs < v_sync_pulse else '1';

                                        --Enable video out when within the porches
  vidon <= '1' when hcs >= h_front_offset and hcs < h_back_offset
           and vcs >= v_front_offset and vcs < v_back_offset else '0';

                                        -- output horizontal and vertical counters
  hc <= hcs - h_front_offset when h_front_offset <= hcs and hcs < h_back_offset else (others => '1');
  vc <= vcs - v_front_offset when v_front_offset <= vcs and vcs < v_back_offset else (others => '1');
	  
	
	  
end Behavioral;
