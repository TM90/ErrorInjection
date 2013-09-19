----------------------------------------------------------------------------------
-- Company:         KIT Campus Nord/IPE
-- Engineer:        Tobias Markus
-- 
-- Create Date: 03.06.2013 09:32:12
-- Design Name: 
-- Module Name: TMR - Behavioral
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
use WORK.TMR_FSM_H3_pack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TMR_FSM_H3 is
    port(
        CLK             : in clk_type;
        RST             : in rst_type;
        DATA_IN_TMR     : in data_in_type;
        Trig_IO         : out trig_type
    );
end TMR_FSM_H3;

architecture Behavioral of TMR_FSM_H3 is

signal state_voter 	: state_type;
signal trig_voter	: trig_type;
signal sync_int		: sync_type;
signal sync_1_int	: sync_type;
signal trig_int_IO 	: trig_type;
signal trig_err		: err_type;

component TestFSM_H3 is
    Port ( CLK 		: in std_logic;
           RST 		: in STD_LOGIC;
		   SYNC		: in std_logic;
		   SYNC_1	: in std_logic;
           DATA_IN 	: in STD_LOGIC;
           TRIG_reg : out STD_LOGIC;
		   state	: out std_logic_vector(4 downto 0)
		   );
end component;

component voter_fsm_H3 is
    Port ( 
           CLK 		: in std_logic;
		   RST		: in std_logic;
		   TRIG		: in trig_type;
		   STATE	: in state_type;
		   SYNC		: out std_logic;
		   SYNC_1	: out std_logic;
		   TRIG_OUT_IO : out std_logic;
		   Trig_err : out std_logic
    );
end component;

begin

GENTMR:for I in 0 to 2 generate
	Modul:TestFSM_H3 
	port map(
		CLK			=> CLK(I),
		RST			=> RST(I),
		SYNC		=> sync_int(I),
		SYNC_1		=> sync_1_int(I),
        DATA_IN		=> DATA_IN_TMR(I),
        TRIG_reg	=> trig_voter(I),
		state		=> state_voter(I)
	);
end generate;

GENVOT:for I in 0 to 2 generate
	ModulVoter:voter_fsm_H3
	port map(
        CLK			=> CLK(I),
		RST			=> RST(I),
		TRIG		=> trig_voter,
		STATE		=> state_voter,
		SYNC		=> sync_int(I),
		SYNC_1		=> sync_1_int(I),
		TRIG_OUT_IO	=> trig_int_IO(I),
		Trig_err	=> trig_err(I)
	);
end generate;

Trig_IO(0) <= trig_int_IO(0) when trig_err(0)='0' else 'Z';
Trig_IO(1) <= trig_int_IO(1) when trig_err(1)='0' else 'Z';
Trig_IO(2) <= trig_int_IO(2) when trig_err(2)='0' else 'Z';

end Behavioral;


