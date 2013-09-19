----------------------------------------------------------------------------------
-- Company:     KIT Campus Nord/IPE
-- Engineer:    Tobias Markus
-- 
-- Create Date: 03.06.2013 13:04:21
-- Design Name: 
-- Module Name: VOTER - Behavioral
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

entity voter_fsm_H3 is
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
end voter_fsm_H3;

architecture Behavioral of voter_fsm_H3 is

signal state_valid 	: trig_type;
signal comp_trig	: trig_type;
signal state_reg	: state_type;

begin

pipeline:process(RST,CLK)
begin
if(rising_edge(CLK)) then
	state_reg <= STATE;
end if;

end process;

comp_trig(0)	<= TRIG(0) xor TRIG(1);
comp_trig(1)	<= TRIG(1) xor TRIG(2);
comp_trig(2)	<= TRIG(0) xor TRIG(2);

compare:process(STATE,TRIG,comp_trig)
begin
	if(comp_trig(0) = '1' and comp_trig(1) = '1' and comp_trig(2) = '1') then
		Trig_ERR <= '1';
	else
		Trig_ERR <= '0';
	end if;
	
	if((STATE(0) = "11001" and STATE(1) = "11001") or (STATE(1) = "11001" and STATE(2) = "11001") or (STATE(0)= "11001" and STATE(2) = "11001")) then
		SYNC_1 <= '1';
	else
		SYNC_1 <= '0';
	end if;
	if( STATE(0)="11001" or STATE(1)="11001" or STATE(2)="11001" or
		STATE(0)="11000" or STATE(1)="11000" or STATE(2)="11000" or
		STATE(0)="11011" or STATE(1)="11011" or STATE(2)="11011" or
		STATE(0)="11101" or STATE(1)="11101" or STATE(2)="11101" or
		STATE(0)="10001" or STATE(1)="10001" or STATE(2)="10001" or
		STATE(0)="01001" or STATE(1)="01001" or STATE(2)="01001") then
		SYNC <= '1';
	else
		SYNC <= '0';
	end if;
	
	if(comp_trig(0) = '0') then
		TRIG_OUT_IO <= TRIG(0);
	elsif(comp_trig(1) = '0') then
		TRIG_OUT_IO <= TRIG(1);
	elsif(comp_trig(2) = '0' ) then
		TRIG_OUT_IO <= TRIG(2);
	end if;
	
end process;

end Behavioral;
