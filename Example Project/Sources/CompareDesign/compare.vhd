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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compare is
    Port(  INPUT_TMR0	: in std_logic;
		   INPUT_TMR1	: in std_logic;
		   INPUT_TMR2 	: in std_logic;
		   INPUT_GOLD	: in std_logic;
		   DONE 		: in std_logic;
		   DATA_OUT		: out std_logic_vector(7 downto 0);
		   WR			: out std_logic);
end compare;

architecture Behavioral of compare is

signal count : unsigned(3 downto 0):="0000";

begin

WR <= '1' when DONE ='0' else '0';

process(INPUT_TMR0,INPUT_TMR1,INPUT_TMR2,INPUT_GOLD)
begin
    if(((INPUT_TMR0 = INPUT_GOLD) and (INPUT_TMR1 = INPUT_GOLD)) or 
      ((INPUT_TMR0 = INPUT_GOLD) and (INPUT_TMR2 = INPUT_GOLD)) or
      ((INPUT_TMR1 = INPUT_GOLD) and (INPUT_TMR2 = INPUT_GOLD))) then
        DATA_OUT <= std_logic_vector(to_unsigned(character'pos('C'),8));
    else
        DATA_OUT <= std_logic_vector(to_unsigned(character'pos('E'),8));
    end if;
end process;
end Behavioral;
