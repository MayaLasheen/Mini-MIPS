library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--use IEEE.STD_LOGIC_SIGNED.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execute is
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
end Execute;

architecture Behavioral of Execute is

component MUX2to1 is
    generic (
        size : integer := 5
    );
    Port ( x : in STD_LOGIC_VECTOR (size-1 downto 0);
           y : in STD_LOGIC_VECTOR (size-1 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (size-1 downto 0));
end component;

component MUX3to1 is
    generic (
        size : integer := 32
    );
    Port ( x0 : in STD_LOGIC_VECTOR (size-1 downto 0);
           x1  : in STD_LOGIC_VECTOR (size-1 downto 0);
           x2  : in STD_LOGIC_VECTOR (size-1 downto 0);
           s : in STD_LOGIC_VECTOR (1 DOWNTO 0);
           z : out STD_LOGIC_VECTOR (size-1 downto 0));
end component;

signal op1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal op2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal intermediateOp2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal forwarded10 : STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

--MUX5bits : MUX2to1 port map (Rt, Rd, regDst, writeReg);

MUX32Bits1 : MUX2to1 generic map (size => 32) port map (dataR3E, signImmE, IRE, intermediateOp2);
MUX32Bits2 : MUX3to1 port map (dataR2E, resultW, ALUOutM, forwardAE, op1);
MUX32Bits3 : MUX3to1 port map (intermediateOp2, resultW, ALUOutM, forwardBE, op2);
MUX32Bits4 : MUX3to1 port map (in_dataR1E, resultW, ALUOutM, forwardStore, out_dataR1E);

--MUX32Bits5 : MUX2to1 generic map (size => 32) port map (ALUOutM, readDataM, memToRegM, forwarded10);

out_R1E <= in_R1E;
out_R2E <= in_R2E;
out_R3E <= in_R3E;
out_memToRegE <= in_memToRegE;
out_memWriteE <= in_memWriteE;
out_regWriteEnE <= in_regWriteEnE;

process (ALUControlE, op1, op2)
begin
    case (ALUControlE) is
        when "0000000001" => ALUOutE <= op1 + op2; --ADD
        when "0000000010" => ALUOutE <= op1 - op2; --SUB
        when "0000001000" => ALUOutE <= op1 AND op2; --AND
        when "0000010000" => ALUOutE <= op1 OR op2; --OR
        when "0000100000" => ALUOutE <= op1 + op2; --LOAD
        when "0001000000" => ALUOutE <= op1 + op2; --STORE
        -- when "0010000000" => ALUOutE <= op1 + op2; --JUMP
        -- when "0100000000" => ALUOutE <= op1 - op2; --BRANCH
        when others => ALUOutE <= x"00000000"; -- Default case
     end case;
end process;

end Behavioral;
