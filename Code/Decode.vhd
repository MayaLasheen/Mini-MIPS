library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decode is
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
           forwardD1: in STD_LOGIC;
           forwardD2: in STD_LOGIC;
           branchD : inout STD_LOGIC);
end Decode;

architecture Behavioral of Decode is

    component ControlUnit is
    Port ( opCode : in STD_LOGIC_VECTOR (9 downto 0);
           IRIndicator : in STD_LOGIC_VECTOR (6 downto 0);
           regWriteEnD : out STD_LOGIC;
           memToRegD : out STD_LOGIC;
           memWriteD : out STD_LOGIC;
           branchD : out STD_LOGIC;
           ALUControlD : out STD_LOGIC_VECTOR (9 downto 0);
           IRD : out STD_LOGIC;
           immPositionD : out STD_LOGIC;
           jumpD : out STD_LOGIC;
           reset : STD_LOGIC);
    end component;
    
    component RegisterFile is
    Port ( clk : in STD_LOGIC;
           R1D : in STD_LOGIC_VECTOR (4 downto 0);
           R2D : in STD_LOGIC_VECTOR (4 downto 0);
           R3D : in STD_LOGIC_VECTOR (4 downto 0);
           dataR1D : inout STD_LOGIC_VECTOR (31 downto 0);
           dataR2D : out STD_LOGIC_VECTOR (31 downto 0);
           dataR3D : out STD_LOGIC_VECTOR (31 downto 0);
           regWriteEnW : in STD_LOGIC;
           R1W : in STD_LOGIC_VECTOR (4 downto 0);
           resultW : in STD_LOGIC_VECTOR (31 downto 0);
           reset : STD_LOGIC);
    end component;
    
    component SignExtend is
    Port ( immediate : in STD_LOGIC_VECTOR (4 downto 0);
           signImmD : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component BranchOrJumpPC is
    Port ( signImmD : in STD_LOGIC_VECTOR (31 downto 0);
           dataR1D : in STD_LOGIC_VECTOR (31 downto 0);
           dataR2D : in STD_LOGIC_VECTOR (31 downto 0);
           jumpD : in STD_LOGIC;
           PCBranchD : out STD_LOGIC_VECTOR (31 downto 0));
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

    -- 31 register, each of the size of 32 bits.
    signal immPositionD : STD_LOGIC;
    signal jumpD : STD_LOGIC;
    signal R1Check : STD_LOGIC;
    signal R1Value : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal R2Value : STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

MUX5Bits1 : MUX2to1 port map (instrD (4 DOWNTO 0), instrD (9 DOWNTO 5), immPositionD, R2D);
MUX5Bits2 : MUX2to1 port map (instrD (9 DOWNTO 5), instrD (4 DOWNTO 0), immPositionD, R3D);

MUX32Bits1 : MUX2to1 generic map (size => 32) port map (dataR1D, ALUOutM, forwardD1, R1Value);
MUX32Bits2 : MUX2to1 generic map (size => 32) port map (dataR2D, ALUOutM, forwardD2, R2Value);
R1Check <= '1' when (R1Value = x"00000000") else '0';
PCSrcD <= (R1Check AND branchD) or jumpD;

process (instrD (14 DOWNTO 10)) 
begin
    R1D <= instrD (14 DOWNTO 10);
end process;

CU : ControlUnit port map (instrD(31 downto 22), instrD(21 downto 15), regWriteEnD,
    memToRegD, memWriteD, branchD, ALUControlD, IRD, immPositionD, jumpD, reset);
    
SE : SignExtend port map (R3D, signImmD);

RF : RegisterFile port map (clk, R1D, R2D, R3D, dataR1D,
    dataR2D, dataR3D, regWriteEnW, R1W, resultW, reset);

PCAddress : BranchOrJumpPC port map(signImmD, R1Value, R2Value, jumpD,
           PCBranchD);

end Behavioral;
