library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS is
  Port ( clk : in STD_LOGIC;
         -- initialPC : inout STD_LOGIC_Vector (31 downto 0);
         reset : in STD_LOGIC);
end MIPS;

architecture Behavioral of MIPS is

    type RAM is array(0 TO 63) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal dataMemory : RAM;
    signal instrMemory : RAM;
    -- type registerFile is array(0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal regFile : registerFile;
 
---------------------------------------------------------------------------------------------  
-- Fetch
---------------------------------------------------------------------------------------------  
    component Fetch is
        Port ( clk : in STD_LOGIC;
               -- PC : inout STD_LOGIC_Vector (31 downto 0);
               PCF : inout STD_LOGIC_Vector (31 downto 0);
               -- The address of the current instruction is kept in a 32-bit register called the program counter (PC).
               -- rst: in STD_LOGIC;
               -- The program counter must have a reset signal to initialize its value when the processor turns on.
               --instrF : out STD_LOGIC_VECTOR (31 downto 0);
               stallF : in STD_LOGIC;
               PCSrcD : in STD_LOGIC;
               PCBranchD : in STD_LOGIC_VECTOR (31 downto 0);
               reset : in STD_LOGIC);            
    end component;   
    
    signal PCF : STD_LOGIC_Vector (31 downto 0);
    signal instrF : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal stallF: STD_LOGIC;
    signal PCSrcD: STD_LOGIC;
     
    component DFF_FD is
    Port ( clk : in STD_LOGIC;
           En: in STD_LOGIC;
           CLR: in STD_LOGIC;
           reset : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (31 downto 0);
           Q : inout STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
---------------------------------------------------------------------------------------------       
-- Decode
--------------------------------------------------------------------------------------------- 
    component Decode is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           instrD : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           resultW : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           R1W: in STD_LOGIC_VECTOR (4 DOWNTO 0);
           PCBranchD : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           regWriteEnD : out STD_LOGIC;
           memToRegD : out STD_LOGIC;
           memWriteD : out STD_LOGIC;
           PCSrcD : out STD_LOGIC;
           ALUControlD : out STD_LOGIC_VECTOR (9 DOWNTO 0);
           IRD : out STD_LOGIC;
           R1D : inout STD_LOGIC_VECTOR (4 DOWNTO 0);
           R2D : inout STD_LOGIC_VECTOR (4 DOWNTO 0);
           R3D : inout STD_LOGIC_VECTOR (4 DOWNTO 0);
           dataR1D : inout STD_LOGIC_VECTOR (31 DOWNTO 0);
           dataR2D  : inout STD_LOGIC_VECTOR (31 DOWNTO 0);
           dataR3D : out STD_LOGIC_VECTOR (31 DOWNTO 0); 
           signImmD : inout STD_LOGIC_VECTOR (31 DOWNTO 0);
           regWriteEnW : in STD_LOGIC;
           ALUOutM : in STD_LOGIC_VECTOR (31 DOWNTO 0); 
           forwardD1 : in STD_LOGIC;
           forwardD2 : in STD_LOGIC;
           branchD : inout STD_LOGIC);
    end component;
    
    signal PCBranchD : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal forwardD1 : STD_LOGIC;
    signal forwardD2 : STD_LOGIC;
    signal branchD : STD_LOGIC;
    signal instrD : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal stallD : STD_LOGIC;
    signal flushE : STD_LOGIC;
    signal regWriteEnD : STD_LOGIC;
    signal memToRegD : STD_LOGIC;
    signal memWriteD : STD_LOGIC;
    signal ALUControlD : STD_LOGIC_VECTOR (9 DOWNTO 0);
    signal IRD : STD_LOGIC;
    signal R1D : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal R2D : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal R3D : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal dataR1D : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal dataR2D  : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal dataR3D : STD_LOGIC_VECTOR (31 DOWNTO 0); 
    signal signImmD : STD_LOGIC_VECTOR (31 DOWNTO 0);

    component DFF_DE is
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
    end component;
---------------------------------------------------------------------------------------------  
-- Execute
--------------------------------------------------------------------------------------------- 
    component Execute is
        Port ( in_regWriteEnE : in STD_LOGIC;
               in_memToRegE : in STD_LOGIC;
               in_memWriteE : in STD_LOGIC;
               out_regWriteEnE : out STD_LOGIC;
               out_memToRegE : out STD_LOGIC;
               out_memWriteE : out STD_LOGIC;
               ALUControlE: in STD_LOGIC_VECTOR (9 downto 0);
               IRE : in STD_LOGIC;
               in_R1E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
               in_R2E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
               in_R3E : in STD_LOGIC_VECTOR (4 DOWNTO 0);
               out_R1E : out STD_LOGIC_VECTOR (4 DOWNTO 0);
               out_R2E : out STD_LOGIC_VECTOR (4 DOWNTO 0);
               out_R3E : out STD_LOGIC_VECTOR (4 DOWNTO 0);
               in_dataR1E : in STD_LOGIC_VECTOR (31 DOWNTO 0);
               out_dataR1E : out STD_LOGIC_VECTOR (31 DOWNTO 0);
               dataR2E : in STD_LOGIC_VECTOR (31 downto 0);
               dataR3E : in STD_LOGIC_VECTOR (31 downto 0);
               signImmE : in STD_LOGIC_VECTOR (31 downto 0);
               ALUOutM : in STD_LOGIC_VECTOR (31 downto 0);
               resultW : in STD_LOGIC_VECTOR (31 downto 0);
               forwardAE: in STD_LOGIC_VECTOR (1 DOWNTO 0);
               forwardBE : in STD_LOGIC_VECTOR (1 DOWNTO 0);
               forwardStore : in STD_LOGIC_VECTOR (1 DOWNTO 0);
               ALUOutE : out STD_LOGIC_VECTOR (31 downto 0);
               readDataM : in STD_LOGIC_VECTOR (31 downto 0);
               memToRegM : in STD_LOGIC);
    end component;
   
    signal in_regWriteEnE : STD_LOGIC;
    signal in_memToRegE : STD_LOGIC;
    signal in_memWriteE : STD_LOGIC;
    signal out_regWriteEnE : STD_LOGIC;
    signal out_memToRegE : STD_LOGIC;
    signal out_memWriteE : STD_LOGIC;
    signal ALUControlE: STD_LOGIC_VECTOR (9 downto 0);
    signal IRE : STD_LOGIC;
    signal in_R1E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal in_R2E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal in_R3E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal out_R1E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal out_R2E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal out_R3E : STD_LOGIC_VECTOR (4 DOWNTO 0);
    signal in_dataR1E : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal out_dataR1E : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal dataR2E : STD_LOGIC_VECTOR (31 downto 0);
    signal dataR3E : STD_LOGIC_VECTOR (31 downto 0);
    signal signImmE : STD_LOGIC_VECTOR (31 downto 0);
    signal forwardAE: STD_LOGIC_VECTOR (1 DOWNTO 0);
    signal forwardBE : STD_LOGIC_VECTOR (1 DOWNTO 0);
    signal forwardStore : STD_LOGIC_VECTOR (1 downto 0);
    signal ALUOutE : STD_LOGIC_VECTOR (31 downto 0);

    component DFF_EM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           D1 : in STD_LOGIC;
           D2 : in STD_LOGIC;
           D3 : in STD_LOGIC;
           D4 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D5 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
           D6 : in STD_LOGIC_VECTOR (31 downto 0);
           D7 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           D8 : in STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q1 : out STD_LOGIC;
           Q2 : out STD_LOGIC;
           Q3 : out STD_LOGIC;
           Q4 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q5 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
           Q6 : out STD_LOGIC_VECTOR (31 downto 0);
           Q7 : out STD_LOGIC_VECTOR (4 DOWNTO 0);
           Q8 : out STD_LOGIC_VECTOR (4 DOWNTO 0));
    end component;
---------------------------------------------------------------------------------------------
-- Memory 
---------------------------------------------------------------------------------------------   
    component Memory is
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
    end component;   
    
    signal dataR1M : STD_LOGIC_VECTOR (31 downto 0);
    signal in_R1M : STD_LOGIC_VECTOR (4 downto 0); -- Traget Address R 
    signal in_R2M : STD_LOGIC_VECTOR (4 downto 0);
    signal in_R3M : STD_LOGIC_VECTOR (4 downto 0);
    signal out_R1M : STD_LOGIC_VECTOR (4 downto 0); -- Traget Address R 
    signal out_R2M : STD_LOGIC_VECTOR (4 downto 0);
    signal out_R3M : STD_LOGIC_VECTOR (4 downto 0);
    signal in_ALUOutM : STD_LOGIC_VECTOR (31 downto 0); -- Address in Store
    signal out_ALUOutM : STD_LOGIC_VECTOR (31 downto 0);
    signal readDataM : STD_LOGIC_VECTOR (31 downto 0);
    signal in_regWriteEnM : STD_LOGIC;
    signal in_memToRegM : STD_LOGIC;
    signal out_regWriteEnM : STD_LOGIC;
    signal out_memToRegM : STD_LOGIC;
    signal memWriteM : STD_LOGIC;
    
    component DFF_MW is
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
    end component;
---------------------------------------------------------------------------------------------   
-- Write Back
--------------------------------------------------------------------------------------------- 
    component WriteBack is
    Port ( in_regWriteEnW : in STD_LOGIC;
           out_regWriteEnW : out STD_LOGIC;
           memToRegW : in STD_LOGIC;
           in_R1W : in STD_LOGIC_VECTOR (4 downto 0);
           out_R1W : out STD_LOGIC_VECTOR (4 downto 0);
           ALUOutW : in STD_LOGIC_VECTOR (31 downto 0);
           readDataW : in STD_LOGIC_VECTOR (31 downto 0);
           resultW : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal dataR1W : STD_LOGIC_VECTOR (31 downto 0);
    signal in_R1W : STD_LOGIC_VECTOR (4 downto 0); -- Traget Address R 
    signal out_R1W : STD_LOGIC_VECTOR (4 downto 0); -- Traget Address R 
    signal ALUOutW : STD_LOGIC_VECTOR (31 downto 0); -- Address in Store
    signal readDataW : STD_LOGIC_VECTOR (31 downto 0);
    signal in_regWriteEnW : STD_LOGIC;
    signal out_regWriteEnW : STD_LOGIC;
    signal memToRegW : STD_LOGIC;
    signal memWriteW : STD_LOGIC;
    signal resultW : STD_LOGIC_VECTOR (31 downto 0);
    
--------------------------------------------------------------------------------------------- 
-- Hazard Unit
--------------------------------------------------------------------------------------------- 
component HazardUnit is
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
         reset : in STD_LOGIC;
         forwardStore : out STD_LOGIC_VECTOR (1 DOWNTO 0);
         memWriteE : in STD_LOGIC);
end component;

begin

instrMemory(0) <= "00000000010000001000010001000111";
-- ADDI R1, R2, 7
-- R2 + 7 -> R1 
-- R1 = 7

instrMemory(1) <= "00000000010000001000110000100101";
-- ADDI R3, R1, 5
-- R1 + 5 -> R3 
-- R3 = 12 = C

instrMemory(2) <= "00010000000000001000010010100000";
-- Store R1, 5, R0 
-- R1 -> To Address (R0 + 5)
-- Value 7 is Stored at Address 5

instrMemory(3) <= "00001000000000001001000010100101";
-- Load R4, 5, R5
-- Data Inside Address (R5 + 5) -> R4 
-- Load Value 7 to component R4

-- instrMemory(4) <= "00000010000000001001010001100001";
-- AND R5, R3, R1
-- 12 AND 7 -> R5
-- R5 = 1100 AND 0111 = 0100 = 4
instrMemory(4) <= "00000000010000001000100010000111";
-- ADDI R2, R4, 7
-- R4 + 7 -> R2
-- R2 = E

instrMemory(5) <= "00000000100000000000010000100001";
-- SUB R1, R1, R1
-- R1 = 0

instrMemory(6) <= "01000000000000001000010001100011";
-- Branch Taken
-- Branch R1, 3, R3
-- PC = R3 + 5 = 12 + 3 = 15 if R1 = 0

-- instrMemory(6) <= "01000000000000001000010001100011";
-- Branch Not Taken
-- Branch R1, 3, R3
-- PC = R3 + 5 = 12 + 3 = 15 if R1 = 0

--instrMemory(6) <= "01000000000000001000000001100011";
-- Branch Taken
-- Branch R0, 3, R3
-- PC = R3 + 5 = 12 + 3 = 15 if R0 = 0

-- instrMemory(4) <= "00000010000000001001010001100001";
-- AND R5, R3, R1
-- 12 AND 7 -> R5
-- R5 = 1100 AND 0111 = 0100 = 4
-- instrMemory(3) <= "00000100000000001001010001100001";
-- OR R5, R3, R1
-- 12 OR 7 -> R5
-- R5 = F
--------------------------------------------------------------------------------------------------
-- Fetch
--------------------------------------------------------------------------------------------------
-- FetchStage : Fetch port map (clk, initialPC, PCF, stallF, PCSrcD, PCBranchD, reset);
FetchStage : Fetch port map (clk, PCF, stallF, PCSrcD, PCBranchD, reset);
instrF <=  instrMemory(to_integer(unsigned(PCF)));
D_FD : DFF_FD port map (clk, stallD, PCSrcD, reset, instrF, instrD);
--------------------------------------------------------------------------------------------------
-- Decode
--------------------------------------------------------------------------------------------------
DecodeStage : Decode port map (clk, reset, instrD, resultW, out_R1W, PCBranchD, regWriteEnD,
                               memToRegD, memWriteD, PCSrcD, ALUControlD, IRD, R1D, R2D, R3D, dataR1D, 
                               dataR2D, dataR3D, signImmD, out_regWriteEnW, out_ALUOutM, forwardD1, forwardD2, branchD);
           
D_DE : DFF_DE port map (clk, flushE, reset, regWriteEnD, memToRegD, memWriteD, ALUControlD, IRD, 
                        R1D, R2D, R3D, dataR1D, dataR2D, dataR3D, signImmD, 
                        in_regWriteEnE, in_memToRegE, in_memWriteE, ALUControlE,
                        IRE, in_R1E, in_R2E, in_R3E, in_dataR1E, dataR2E, dataR3E, signImmE);
--------------------------------------------------------------------------------------------------
-- Execute
--------------------------------------------------------------------------------------------------
ExecuteStage : Execute port map (in_regWriteEnE, in_memToRegE, in_memWriteE, out_regWriteEnE, out_memToRegE,
                                 out_memWriteE, ALUControlE, IRE, in_R1E, in_R2E, in_R3E, out_R1E, out_R2E, 
                                 out_R3E, in_dataR1E, out_dataR1E, dataR2E, dataR3E, signImmE, out_ALUOutM,
                                  resultW, forwardAE, forwardBE, forwardStore, ALUOutE, readDataM, out_memToRegM);
D_EM : DFF_EM port map (clk, reset, out_regWriteEnE, out_memToRegE, out_memWriteE, out_R1E, out_dataR1E, 
                        ALUOutE, out_R2E, out_R3E, in_regWriteEnM, in_memToRegM, memWriteM, in_R1M, dataR1M, 
                        in_ALUOutM, in_R2M, in_R3M);                             
--------------------------------------------------------------------------------------------------
-- Memory
--------------------------------------------------------------------------------------------------
MemoryStage : Memory port map (clk, reset, dataR1M, in_R1M, out_R1M, in_ALUOutM, out_ALUOutM, readDataM, 
                               in_regWriteEnM, in_memToRegM, out_regWriteEnM, out_memToRegM, memWriteM,
                               in_R2M, in_R3M, out_R2M, out_R3M);

D_MW : DFF_MW port map (clk, reset, out_regWriteEnM, out_memToRegM, out_R1M, out_ALUOutM, readDataM,
                        in_regWriteEnW, memToRegW, in_R1W, ALUOutW, readDataW);
--------------------------------------------------------------------------------------------------
-- Write Back
--------------------------------------------------------------------------------------------------
WriteBackStage : WriteBack port map (in_regWriteEnW, out_regWriteEnW, memToRegW, in_R1W, out_R1W, ALUOutW, readDataW, resultW);
--------------------------------------------------------------------------------------------- 
-- Hazard Unit
--------------------------------------------------------------------------------------------- 
HU : HazardUnit port map (out_memToRegE, out_memToRegM, out_regWriteEnE, out_regWriteEnM, out_regWriteEnW, 
                           out_R1E, out_R2E, out_R3E, R1D, R2D, R3D, out_R1M, out_R1W, stallF, stallD,
                           flushE, forwardAE, forwardBE, forwardD1, forwardD2, branchD, reset, forwardStore, out_memWriteE);

end Behavioral;
