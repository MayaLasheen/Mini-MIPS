library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Fetch is
    Port ( clk : in STD_LOGIC;
           -- PC : inout STD_LOGIC_Vector (31 downto 0);
           PCF : inout STD_LOGIC_Vector (31 downto 0);
           -- The address of the current instruction is kept in a 32-bit register called the program counter (PC).
           -- rst: in STD_LOGIC;
           -- The program counter must have a reset signal to initialize its value when the processor turns on.
           -- instrF : out STD_LOGIC_VECTOR (31 downto 0);
           stallF : in STD_LOGIC;
           PCSrcD : in STD_LOGIC;
           PCBranchD : in STD_LOGIC_VECTOR (31 downto 0);
           reset : in STD_LOGIC);           
end Fetch;

architecture Behavioral of Fetch is
    --Since MIPS memory is word addressable,so 32-bit (4-byte) instruction addresses advance by 4 bytes, not 1.
    --type RAM is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
    --signal Memory : RAM;
    signal PCPlus4F : STD_LOGIC_VECTOR (31 downto 0);
    signal PC : STD_LOGIC_Vector (31 downto 0);
    --signal PCF : STD_LOGIC_VECTOR (31 downto 0);
    
    
    component DFF is
    generic ( size : integer := 32);
    Port ( clk : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (size-1 downto 0);
           EN : in STD_LOGIC;
           CLR: in STD_LOGIC;
           Q : inout STD_LOGIC_VECTOR (size-1 downto 0));
    end component;
    
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
    --instrF <=  Memory(to_integer(unsigned(PCF)));
    MUX32bits : MUX2to1 generic map (size => 32) port map (PCPlus4F, PCBranchD, PCSrcD, PC);
    PCPlus4F <= PCF + 1;
    --PCPlus4F <= PCF;
    FF : DFF port map (clk, PC, stallF, reset, PCF);
end Behavioral;
