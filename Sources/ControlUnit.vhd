library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
    Port ( opCode : in STD_LOGIC_VECTOR (9 downto 0);
           IRIndicator : in STD_LOGIC_VECTOR (6 downto 0);
           regWriteEnD : out STD_LOGIC; --
           memToRegD : out STD_LOGIC; --
           memWriteD : out STD_LOGIC; --
           branchD : out STD_LOGIC; --
           ALUControlD : out STD_LOGIC_VECTOR (9 downto 0);
           IRD : out STD_LOGIC; --
           immPositionD : out STD_LOGIC;
           jumpD : out STD_LOGIC;
           reset : in STD_LOGIC); --
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

    ALUControlD <= opCode;
    IRD <= '1' when (((IRIndicator(0) = '1') AND (opCode = "0000000001" OR opCode = "0000000010"))
                 OR (opCode = "0000100000") 
                 OR (opCode = "0001000000")
                 OR (opCode = "0010000000")
                 OR (opCode = "0100000000"))
                 else '0';
    immPositionD <= '0' when (opCode = "0000100000" 
                           OR opCode = "0001000000"
                           OR opCode = "0010000000"
                           OR opCode = "0100000000")
                           else '1';
                           
    
    process (opCode, reset)
    begin
        if (reset = '1') then 
            memToRegD <= '0'; memWriteD <= '0'; jumpD <= '0'; branchD <= '0';
        else
            if (opCode = "0000100000") then -- Load
                memToRegD <= '1';
            else
                memToRegD <= '0';
            end if;
            if (opCode = "0001000000") then -- Store
                memWriteD <= '1';
            else
                memWriteD <= '0';
            end if;
            if (opCode = "0010000000") then
                jumpD <= '1';
            else
                jumpD <= '0';
            end if;
            if (opCode = "0100000000") then -- Branch
                branchD <= '1'; 
            else
                branchD <= '0';
            end if;
        end if;           
    end process;
    
    process (opCode, reset)
    begin
        if (reset = '1') then regWriteEnD <= '0';
        else
            if (opCode /= "0001000000") then -- Not Store
                if (opCode /= "0010000000") then -- Not Jump
                    if (opCode/= "0100000000") then -- Not Branch
                        regWriteEnD <= '1';
                    else
                        regWriteEnD <= '0';
                    end if;
                else
                    regWriteEnD <= '0';
                end if;
            else
                regWriteEnD <= '0';
            end if;  
        end if;         
    end process;

end Behavioral;
