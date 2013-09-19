----------------------------------------------------------------------------------
-- Company:     KIT Campus Nord/IPE
-- Engineer:    Tobias Markus
-- 
-- Create Date: 03.06.2013 09:49:54
-- Design Name: 
-- Module Name: TestFSM - Behavioral
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

entity TestFSM_H3 is
    Port ( CLK 		: in std_logic;
           RST 		: in STD_LOGIC;
		   SYNC		: in std_logic;
		   SYNC_1	: in std_logic;
           DATA_IN 	: in STD_LOGIC;
           TRIG_reg : out STD_LOGIC;
		   state	: out std_logic_vector(4 downto 0)
		   );
end TestFSM_H3;

architecture Behavioral of TestFSM_H3 is

signal state_reg : std_logic_vector(4 downto 0):="00000";

begin
	state <= state_reg;
Trigger:process(CLK,RST)
begin
	if(RST = '1') then 
		state_reg <= "00000";
	elsif(rising_edge(CLK)) then 
		case state_reg is 
			when "00000"|"00001"|"00010"|"00100"|"01000"|"10000" =>
			TRIG_reg <= '0';
				if(DATA_IN = '1') then
					state_reg <= "00111";
				end if;
			when "00111"|"00110"|"00101"|"00011"|"01111"|"10111" =>
				if(DATA_IN = '0') then
					state_reg <= "11001";
				end if;
			when "11001"|"11000"|"11011"|"11101"|"10001"|"01001" =>
				if(SYNC_1 = '1') then
					if(DATA_IN = '1') then
						state_reg <= "00000";
						TRIG_reg <= '1';
					else
						state_reg <= "00000";
					end if;
				end if;
			when others =>
				TRIG_reg <= '0';
				if(SYNC = '1') then
					state_reg <= "00000";
				end if;
		end case;
	end if;
end process;

end Behavioral;
