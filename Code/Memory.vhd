

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataR1M : in STD_LOGIC_VECTOR (31 downto 0); -- Data To Be Written In Memory
           in_R1M : in STD_LOGIC_VECTOR (4 downto 0); -- Traget Address R 
           out_R1M : out STD_LOGIC_VECTOR (4 downto 0); 
           in_ALUOutM : in STD_LOGIC_VECTOR (31 downto 0); -- Address in Store
           out_ALUOutM : out STD_LOGIC_VECTOR (31 downto 0); 
           readDataM : out STD_LOGIC_VECTOR (31 downto 0);
           in_regWriteEnM : in STD_LOGIC;
           in_memToRegM : in STD_LOGIC;
           out_regWriteEnM : out STD_LOGIC;
           out_memToRegM : out STD_LOGIC;
           memWriteM : in STD_LOGIC;
           in_R2M : in STD_LOGIC_VECTOR (4 downto 0);
           in_R3M : in STD_LOGIC_VECTOR (4 downto 0);
           out_R2M : out STD_LOGIC_VECTOR (4 downto 0);
           out_R3M : out STD_LOGIC_VECTOR (4 downto 0));
end Memory;

architecture Behavioral of Memory is

    -- 2^6 = 64
    type RAM is array(0 TO 63) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal dataMemory : RAM;

begin
--    dataMemory(1) <= x"000000FF"; -- Used for Testing
--    Memory(0) <= "00000000000000000000000000110101";

    out_memToRegM <= in_memToRegM;
    out_regWriteEnM <= in_regWriteEnM;
    out_ALUOutM <= in_ALUOutM;
    out_R1M <= in_R1M;
    out_R2M <= in_R2M;
    out_R3M <= in_R3M;
    
    process (clk)
    begin
    if (reset = '1') then
        dataMemory <= (others => x"00000000");
    elsif (rising_edge(clk)) then
        if (memWriteM = '1') then -- Instruction is Store
            dataMemory(to_integer(unsigned(in_ALUOutM))) <= dataR1M;
        end if;
    end if;
    end process;
    
    readDataM <= dataMemory(to_integer(unsigned(in_ALUOutM)));

end Behavioral;
