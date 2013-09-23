----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.07.2013 15:39:42
-- Design Name: 
-- Module Name: Sequencer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use WORK.TMR_FSM_H3_pack.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toplevel_seuInject is
    Port ( 
		CLK		     : in std_logic;
		RST          : in std_logic;
		TXD          : out std_logic
	);
end toplevel_seuInject;

architecture Behavioral of toplevel_seuInject is

attribute keep_hierarchy : string;
attribute keep_hierarchy of Behavioral: architecture is "true";
attribute keep : string;

signal sequence_int 	: std_logic;
attribute keep of sequence_int: signal is "true";
signal input_golden_int : std_logic;
attribute keep of input_golden_int: signal is "true";
signal input_tmr0_int	: std_logic;
attribute keep of input_tmr0_int: signal is "true";
signal input_tmr1_int	: std_logic;
attribute keep of input_tmr1_int: signal is "true";
signal input_tmr2_int	: std_logic;
attribute keep of input_tmr2_int: signal is "true";
signal restart_int		: std_logic;
signal done_int			: std_logic;
signal data_out_int		: std_logic_vector(7 downto 0);
signal wr_int			: std_logic;
signal rd_int           : std_logic;
signal fifo_out_int     : std_logic_vector(7 downto 0);
signal empty_int        : std_logic;
signal clk_30MHz        : std_logic;
signal rst_int          : std_logic;
signal rst_clk          : std_logic;

component CLKManager is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
end component; 

component TMR_FSM_H3 is
    port(
        CLK             : in clk_type;
        RST             : in rst_type;
        DATA_IN_TMR     : in data_in_type;
        Trig_IO         : out trig_type
    );
end component;

component TestFSM_H3 is
    Port ( CLK 			: in std_logic;
           RST 			: in STD_LOGIC;
		   SYNC			: in std_logic;
		   SYNC_1		: in std_logic;
           DATA_IN 		: in STD_LOGIC;
           TRIG_reg 	: out STD_LOGIC;
		   state		: out std_logic_vector(4 downto 0)
		   );
end component;

component Sequencer is
    Port ( CLK 			: in STD_LOGIC;
           RST 			: in STD_LOGIC;
           OUTPUT 		: out STD_LOGIC;
           DONE     	: out std_logic);
end component;

component compare is
    Port ( INPUT_TMR0	: in std_logic;
		   INPUT_TMR1	: in std_logic;
		   INPUT_TMR2 	: in std_logic;
		   INPUT_GOLD	: in std_logic;
		   DONE 		: in std_logic;
		   DATA_OUT		: out std_logic_vector(7 downto 0);
		   WR			: out std_logic);
end component;

COMPONENT fifo_generator_v9_3_1
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

component UARTTX is
	generic (
			baudrate 	: integer := 9600;
			freq		: integer := 30000000
	);
    Port ( CLK 		: in std_logic;
           RST 		: in std_logic;
		   EMPTY	: in std_logic;
           DATA_IN 	: in std_logic_vector(7 downto 0);
		   RD		: out std_logic;
		   TXD		: out std_logic);
end component;

begin

rst_int <= RST or (not rst_clk);

CLKManager_I:CLKManager
port map(
          CLKIN_IN          => CLK,
          RST_IN            => RST,
          CLKFX_OUT         => clk_30MHz,
          CLKIN_IBUFG_OUT   => open,
          CLK0_OUT          => open,    
          LOCKED_OUT        => rst_clk

);

DUT:TMR_FSM_H3
port map(
			CLK(0)			=> clk_30MHz,
			CLK(1)			=> clk_30MHz,
			CLK(2)			=> clk_30MHz,
			RST(0)			=> rst_int,
			RST(1)			=> rst_int,
			RST(2)			=> rst_int,
			DATA_IN_TMR(0)	=> sequence_int,
			DATA_IN_TMR(1)	=> sequence_int,
			DATA_IN_TMR(2)	=> sequence_int,
			Trig_IO(0)		=> input_tmr0_int,
			Trig_IO(1)		=> input_tmr1_int,
			Trig_IO(2)		=> input_tmr2_int
);

Golden:TestFSM_H3
port map(
			CLK				=> clk_30MHz,
			RST				=> rst_int,
			SYNC			=> '1',
			SYNC_1			=> '1',
			DATA_IN			=> sequence_int,
			TRIG_reg		=> input_golden_int,
			state			=> open
);

Sequencer_I:Sequencer
port map(
			CLK 			=> clk_30MHz,
			RST				=> rst_int,
			OUTPUT			=> sequence_int,
			DONE			=> done_int
);

Comparator:compare
port map(
			INPUT_TMR0		=> input_tmr0_int,
			INPUT_TMR1		=> input_tmr1_int,
			INPUT_TMR2		=> input_tmr2_int,
			INPUT_GOLD		=> input_golden_int,
			DONE			=> done_int,
			DATA_OUT		=> data_out_int,
			WR				=> wr_int
);

FIFO_I : fifo_generator_v9_3_1
port map(
            CLK             => clk_30MHz,
            RST             => rst_int,
            DIN             => data_out_int,
            WR_EN           => wr_int,
            RD_EN           => rd_int,
            dout            => fifo_out_int,
            full            => open,
            empty           => empty_int
  );
  
UART_I:UARTTX
generic map(
  			baudrate 	=> 9600,
  			freq		=> 30000000
) 
port map(
  			CLK 		=> clk_30MHz,
  			RST			=> rst_int,
  			EMPTY		=> empty_int,
  			DATA_IN 	=> fifo_out_int,
  			RD			=> rd_int,
  			TXD			=> TXD
  		);

end Behavioral;
