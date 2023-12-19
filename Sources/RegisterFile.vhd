library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( clk : in STD_LOGIC;
           R1D : in STD_LOGIC_VECTOR (4 downto 0); -- Target
           R2D : in STD_LOGIC_VECTOR (4 downto 0); -- FIrst Op
           R3D : in STD_LOGIC_VECTOR (4 downto 0); -- Second Op
           dataR1D : out STD_LOGIC_VECTOR (31 downto 0);
           dataR2D : out STD_LOGIC_VECTOR (31 downto 0);
           dataR3D : out STD_LOGIC_VECTOR (31 downto 0);
           regWriteEnW : in STD_LOGIC;
           R1W : in STD_LOGIC_VECTOR (4 downto 0);
           resultW : in STD_LOGIC_VECTOR (31 downto 0);
           reset : in STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is

    type registerFile is array(0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal regFile : registerFile;

begin
   
    
    process (R1D, R2D, R3D)
    begin
            if (R1D = "00000") then
                dataR1D <= x"00000000";
            else
                dataR1D <= regFile(to_integer(unsigned(R1D)));
            end if;
            if (R2D = "00000") then
                dataR2D <= x"00000000";
            else
                dataR2D <= regFile(to_integer(unsigned(R2D)));
            end if;
            if (R3D = "00000") then
                dataR3D <= x"00000000";
            else
                dataR3D <= regFile(to_integer(unsigned(R3D)));
            end if;
    end process;
    
    process (clk, reset)
    begin
    if (reset = '1') then       
        regFile <= (others => x"00000000");
    elsif (falling_edge(clk)) then
        if (regWriteEnW = '1') then
            regFile(to_integer(unsigned(R1W))) <= resultW;
        end if;
    end if;
    end process;



end Behavioral;
