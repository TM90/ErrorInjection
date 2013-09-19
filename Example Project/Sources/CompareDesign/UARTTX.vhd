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

entity UARTTX is
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
end UARTTX;

architecture Behavioral of UARTTX is

signal uartsymb	: std_logic_vector(9 downto 0);
type statetype is (FifoRead0,FifoRead1,FifoRead2,Send);
signal state : statetype;
signal baudclk : std_logic;
signal baud_counter : integer range 0 to 4095 := 0;
signal count : integer range 0 to 15 := 10;

begin
baudgen:process(CLK,RST)
begin 
	if(RST='1') then 
	elsif(rising_edge(CLK)) then 
		if(baud_counter = freq/baudrate) then 
			baudclk <= '1';
			baud_counter <= 0;
		else 
			baudclk <= '0';
			baud_counter <= baud_counter + 1;
		end if;
	end if;
end process;

process(CLK,RST)
begin
	if(RST='1') then
	   TXD <='1';
	   state <= FifoRead0;
	elsif(rising_edge(CLK)) then
		case state is 
			when FifoRead0 =>
				if(EMPTY = '0') then 
					RD <= '1';
					state <= FifoRead1;
				end if;
			when FifoRead1 =>
			     state <= FifoRead2;
			     RD <= '0';
			when FifoRead2 =>
            	 uartsymb <= "1" & DATA_IN & "0";
                 state <= Send;
			when Send =>
				if(baudclk='1' and count > 0) then 
					TXD <= uartsymb(0);
					uartsymb <= "0" & uartsymb(9 downto 1);
					count <= count - 1;
				elsif(count = 0) then 
					state <= FifoRead0;
					count <= 10;
				end if;
			when others =>
				RD <= '0';
		end case;
	end if;
end process;

end Behavioral;
