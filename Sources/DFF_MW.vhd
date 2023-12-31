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

entity DFF_MW is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           D1 : in STD_LOGIC;
           D2 : in STD_LOGIC;
           D3 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D4 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           D5 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q1 : out STD_LOGIC;
           Q2 : out STD_LOGIC;
           Q3 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q4 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q5 : out STD_LOGIC_VECTOR (31 DOWNTO 0));
end DFF_MW;

architecture Behavioral of DFF_MW is

begin

    process (clk, reset)
    begin
        if (reset = '1') then 
            Q1 <= '0';
            Q2 <= '0';
            Q3 <= (others => '0');
            Q4 <= (others => '0');
            Q5 <= (others => '0');
        elsif(rising_edge(clk)) then
            Q1 <= D1;
            Q2 <= D2;
            Q3 <= D3;
            Q4 <= D4;
            Q5 <= D5;
        end if;
    end process;

end Behavioral;
