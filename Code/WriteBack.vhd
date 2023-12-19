----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2023 09:17:09 PM
-- Design Name: 
-- Module Name: WriteBack - Behavioral
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

entity WriteBack is
    Port ( in_regWriteEnW : in STD_LOGIC;
           out_regWriteEnW : out STD_LOGIC;
           memToRegW : in STD_LOGIC;
           in_R1W : in STD_LOGIC_VECTOR (4 downto 0);
           out_R1W : out STD_LOGIC_VECTOR (4 downto 0);
           ALUOutW : in STD_LOGIC_VECTOR (31 downto 0);
           readDataW : in STD_LOGIC_VECTOR (31 downto 0);
           resultW : out STD_LOGIC_VECTOR (31 downto 0));
end WriteBack;

architecture Behavioral of WriteBack is

    component MUX2to1 is
        generic (
            size : integer := 5
        );
        Port ( x : in STD_LOGIC_VECTOR (size-1 downto 0);
               y : in STD_LOGIC_VECTOR (size-1 downto 0);
               s : in STD_LOGIC;
               z : out STD_LOGIC_VECTOR (size-1 downto 0));
    end component;

begin
    out_regWriteEnW <= in_regWriteEnW;
    out_R1W <= in_R1W;
    MUX32bits : MUX2to1 generic map (size => 32) port map (ALUOutW, readDataW, memToRegW, resultW);

end Behavioral;
