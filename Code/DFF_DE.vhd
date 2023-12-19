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

entity DFF_DE is
    Port ( clk : in STD_LOGIC;
           CLR : in STD_LOGIC;
           reset : in STD_LOGIC;
           D1 : in STD_LOGIC;
           D2 : in STD_LOGIC;
           D3 : in STD_LOGIC;
           D4 : in STD_LOGIC_VECTOR (9 DOWNTO 0);
           D5 : in STD_LOGIC;
           D6 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D7 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D8 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D9 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           D10 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           D11 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           D12 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q1 : out STD_LOGIC;
           Q2 : out STD_LOGIC;
           Q3 : out STD_LOGIC;
           Q4 : out STD_LOGIC_VECTOR (9 DOWNTO 0);
           Q5 : out STD_LOGIC;
           Q6 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q7 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q8 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q9 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q10 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q11 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q12 : out STD_LOGIC_VECTOR (31 DOWNTO 0));
end DFF_DE;

architecture Behavioral of DFF_DE is

begin

    process (clk, CLR, reset)
    begin
        if (reset = '1') then 
            Q1 <= '0';
            Q2 <= '0';
            Q3 <= '0';
            Q4 <= (others => '0');
            Q5 <= '0';
            Q6 <= (others => '0');
            Q7 <= (others => '0');
            Q8 <= (others => '0');
            Q9 <= (others => '0');
            Q10 <= (others => '0');
            Q11 <= (others => '0');
            Q12 <= (others => '0');
        elsif(rising_edge(clk)) then
            if (CLR = '1') then
                Q1 <= '0';
                Q2 <= '0';
                Q3 <= '0';
                Q4 <= (others => '0');
                Q5 <= '0';
                Q6 <= (others => '0');
                Q7 <= (others => '0');
                Q8 <= (others => '0');
                Q9 <= (others => '0');
                Q10 <= (others => '0');
                Q11 <= (others => '0');
                Q12 <= (others => '0');
            else
                Q1 <= D1;
                Q2 <= D2;
                Q3 <= D3;
                Q4 <= D4;
                Q5 <= D5;
                Q6 <= D6;
                Q7 <= D7;
                Q8 <= D8;
                Q9 <= D9;
                Q10 <= D10;
                Q11 <= D11;
                Q12 <= D12;
            end if; 
        end if;
    end process;

end Behavioral;
