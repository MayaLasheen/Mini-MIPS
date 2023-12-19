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

entity DFF6 is
    Port ( clk : in STD_LOGIC;
           D1 : in STD_LOGIC;
           D2 : in STD_LOGIC;
           D3 : in STD_LOGIC;
           D4 : in STD_LOGIC;
           D5 : in STD_LOGIC;
           D6 : in STD_LOGIC_VECTOR (9 downto 0);
           Q1 : out STD_LOGIC;
           Q2 : out STD_LOGIC;
           Q3 : out STD_LOGIC;
           Q4 : out STD_LOGIC;
           Q5 : out STD_LOGIC;
           Q6 : out STD_LOGIC_VECTOR (9 downto 0));
end DFF6;

architecture Behavioral of DFF6 is

begin

    process (clk)
    begin
        if(rising_edge(clk)) then
            Q1 <= D1;
            Q2 <= D2;
            Q3 <= D3;
            Q4 <= D4;
            Q5 <= D5;
            Q6 <= D6;
        end if;
    end process;

end Behavioral;
