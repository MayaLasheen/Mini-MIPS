----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 08:44:24 PM
-- Design Name: 
-- Module Name: MUX2to1 - Behavioral
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

entity MUX3to1 is
    generic (
        size : integer := 32
    );
    Port ( x0 : in STD_LOGIC_VECTOR (size-1 downto 0);
           x1  : in STD_LOGIC_VECTOR (size-1 downto 0);
           x2  : in STD_LOGIC_VECTOR (size-1 downto 0);
           s : in STD_LOGIC_VECTOR (1 DOWNTO 0);
           z : out STD_LOGIC_VECTOR (size-1 downto 0));
end MUX3to1;

architecture Behavioral of MUX3to1 is

begin

z <= x0 when s = "00" else
     x1 when s = "01" else
     x2;
end Behavioral;
