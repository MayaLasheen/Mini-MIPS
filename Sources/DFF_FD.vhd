----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 11:16:49 PM
-- Design Name: 
-- Module Name: DFF6 - Behavioral
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DFF_FD is
    Port ( clk : in STD_LOGIC;
           En: in STD_LOGIC;
           CLR: in STD_LOGIC;
           reset : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (31 downto 0);
           Q : inout STD_LOGIC_VECTOR (31 downto 0));
end DFF_FD;

architecture Behavioral of DFF_FD is

begin

    process (clk, CLR, reset)
    begin
        if (reset = '1') then 
            Q <= (others => '0');
        elsif(rising_edge(clk)) then
            if (CLR = '1') then 
                Q <= (others => '0');
            elsif (En = '0') then
                Q <= D;
            else
                Q <= Q;
            end if;
        end if;
    end process;

end Behavioral;
