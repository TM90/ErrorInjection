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

entity Sequencer is
    Port ( CLK 		: in STD_LOGIC;
           RST 		: in STD_LOGIC;
           OUTPUT 	: out STD_LOGIC;
           DONE     : out std_logic);
end Sequencer;

architecture Behavioral of Sequencer is

signal count : unsigned(3 downto 0):="0000";
signal counter2 : integer := 0;
begin

process(CLK,RST)
begin
    if(RST = '1') then
        count <= "0000";
        counter2 <= 0;
        DONE <= '1';
    elsif(rising_edge(CLK)) then 
        if(count="0000") then
            count <= count+"1";
            OUTPUT <= '1';
        elsif(count="0001") then
            OUTPUT <= '0';
			count <= count+"1";
        elsif(count="0010") then
            OUTPUT <= '1';
			count <= count+"1";
        elsif(count="0011") then
            OUTPUT <= '0';
			count <= count+"1";
        elsif(count="0100") then
            OUTPUT <= '0';
			count <= count+"1";
        elsif(count="0101") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="0110") then
            OUTPUT <= '0';
			count <= count+"1";
		elsif(count="0111") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="1000") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="1001") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="1010") then
            OUTPUT <= '0';
			count <= count+"1";
		elsif(count="1011") then
            OUTPUT <= '0';
			count <= count+"1";
		elsif(count="1100") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="1101") then
            OUTPUT <= '0';
			count <= count+"1";
		elsif(count="1110") then
            OUTPUT <= '1';
			count <= count+"1";
		elsif(count="1111") then
            OUTPUT <= '1';
            if(counter2 = 0) then
                Done <= '0';
            end if;
			if(counter2 < 10) then 
				count <= count+"1";
				counter2 <= counter2 + 1;
			end if;
		    if(counter2 = 10) then
                DONE <='1';
            end if;
        end if;
    end if;
end process;
end Behavioral;
