----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2023 10:30:21 AM
-- Design Name: 
-- Module Name: HazardUnit - Behavioral
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

entity HazardUnit is
  Port ( memToRegE : in STD_LOGIC;
         memToRegM : in STD_LOGIC;
         regWriteEnE : in STD_LOGIC;
         regWriteEnM : in STD_LOGIC;
         regWriteEnW : in STD_LOGIC;
         R1E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R2E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R3E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R1D : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R2D : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R3D : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R1M : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         R1W : in STD_LOGIC_VECTOR (4 DOWNTO 0);
         stallF : out STD_LOGIC;
         stallD : out STD_LOGIC;
         flushE : out STD_LOGIC;
         forwardAE: out STD_LOGIC_VECTOR (1 DOWNTO 0);
         forwardBE : out STD_LOGIC_VECTOR (1 DOWNTO 0);
         forwardD1 : out STD_LOGIC;
         forwardD2 : out STD_LOGIC;
         branchD : in STD_LOGIC;
        -- memWriteD : in STD_LOGIC;
         reset : in STD_LOGIC;
         forwardStore : out STD_LOGIC_VECTOR (1 DOWNTO 0);
         memWriteE : in STD_LOGIC);
end HazardUnit;

architecture Behavioral of HazardUnit is

signal loadStall : STD_LOGIC;
signal branchStall : STD_LOGIC;

begin

    process (reset, R1E, R2D, R3D, memToRegE, branchD, regWriteEnE, R1D, R1M, memToRegM)
    begin
        if (reset = '1') then
            loadStall <= '0';
            branchStall <= '0';
        else
            if (((R1E = R2D) OR (R1E = R3D)) AND (memToRegE = '1')) then
                loadStall <= '1';
            else
                loadStall <= '0';
            end if;
            
            if (branchD = '1') then
                if (regWriteEnE = '1') AND (R1E = R1D) then
                    branchStall <= '1';
                elsif (memToRegM = '1') AND (R1M = R1D) then 
                    branchStall <= '1';
                elsif (regWriteEnE = '1') AND (R1E = R2D) then -- R2 = R3 + 1 then Branch R1, 5, R2
                    branchStall <= '1';
                elsif (memToRegM = '1') AND (R1M = R2D) then 
                    branchStall <= '1';
                else
                    branchStall <= '0';
                end if;
            else
                branchStall <= '0';
            end if;
        end if;
    end process;
    
    stallF <= loadStall OR branchStall;
    stallD <= loadStall OR branchStall;
    flushE <= loadStall OR branchStall;                    

    process (reset, R2E, R1M, regWriteEnM, regWriteEnW, R1W, R3E, R1D, R1E, memWriteE, R2D)
    begin
        if (reset = '1') then
            forwardAE <= "00"; 
            forwardBE <= "00"; 
            forwardD1 <= '0';
            forwardD2 <= '0';
            forwardStore <= "00";
            
        else
                
            if ((R1E /= "00000") AND (R1E = R1M) AND (memWriteE = '1') AND (regWriteEnM = '1')) then
                forwardStore <= "10";
            elsif ((R1E /= "00000") AND (R1E = R1W) AND (memWriteE = '1') AND (regWriteEnW = '1')) then 
                forwardStore <= "01";
            else
                forwardStore <= "00";
            end if;
            
            if ((R2E /= "00000") AND (R2E = R1M) AND (regWriteEnM = '1')) then
                forwardAE <= "10";
            elsif ((R2E /= "00000") AND (R2E = R1W) AND (regWriteEnW = '1')) then
                forwardAE <= "01";
            else 
                forwardAE <= "00";
            end if;
            
            if ((R3E /= "00000") AND (R3E = R1M) AND (regWriteEnM = '1')) then
                forwardBE <= "10";
            elsif ((R3E /= "00000") AND (R3E = R1W) AND (regWriteEnW = '1')) then
                forwardBE <= "01";
            else 
                forwardBE <= "00";
            end if;
            
            if ((R1D /= "00000") AND (R1D = R1M) AND (regWriteEnM = '1')) then
                forwardD1 <= '1';
            else
                forwardD1 <= '0';
            end if;
            
            if ((R2D /= "00000") AND (R2D = R1M) AND (regWriteEnM = '1')) then
                forwardD2 <= '1';
            else
                forwardD2 <= '0';
            end if;
        end if;
    end process;
    
--forwardD <= '1' when (R1D /= "00000") AND (R1D = R1M) AND (regWriteEnM = '1')
--                else '0';
--                else '0';

end Behavioral;
