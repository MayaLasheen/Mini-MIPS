----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 10:42:04 PM
-- Design Name: 
-- Module Name: DFF - Behavioral
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

entity DFF is
    generic ( size : integer := 32);
    Port ( clk : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (size-1 downto 0);
           En : in STD_LOGIC;
           CLR: in STD_LOGIC;
           Q : inout STD_LOGIC_VECTOR (size-1 downto 0));
end DFF;

architecture Behavioral of DFF is

begin
   
    process (clk, CLR)
    begin
        if (CLR = '1') then Q <= (others => '0');
        elsif(rising_edge(clk)) then
            if (En = '0') then
                Q <= D;
            else
                Q <= Q;
            end if;
        end if;
    end process;

end Behavioral;
