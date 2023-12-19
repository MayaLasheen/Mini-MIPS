library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity Clock_Generator is
port ( clk : in std_logic;
       clock_out: out std_logic);
end Clock_Generator;
  
architecture Behavioral of Clock_Generator is
  
signal count : integer := 0;
signal tmp : std_logic := '0';
  
begin
  
    process(clk)
    begin
        clock_out <= clk;
    end process;
end Behavioral;