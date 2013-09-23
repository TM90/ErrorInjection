----------------------------------------------------------------------------------
-- Company:     KIT Campus Nord/IPE
-- Engineer:    Tobias Markus
-- 
-- Create Date: 03.06.2013 11:27:57
-- Design Name: 
-- Module Name: TMR_Pack - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package TMR_FSM_H3_pack is
    type data_in_type   is array(0 to 2) of std_logic;
    type state_type  	is array(0 to 2) of std_logic_vector(4 downto 0);
    type Trig_type      is array(0 to 2) of std_logic;
	type sync_type      is array(0 to 2) of std_logic;
    type err_type       is array(0 to 2) of std_logic;
	type clk_type		is array(0 to 2) of std_logic;
	type rst_type		is array(0 to 2) of std_logic;
end TMR_FSM_H3_pack;

package body TMR_FSM_H3_pack is
end TMR_FSM_H3_pack;

