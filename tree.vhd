-- VHDL Model Created from SGE Symbol tree.sym -- Sep 26 16:41:01 2001

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity TREE is
      Port (      N0 : In    std_logic;
                  N1 : In    std_logic;
                  N2 : In    std_logic;
                  N3 : In    std_logic;
                  N4 : In    std_logic;
                  N5 : In    std_logic;
                  N6 : In    std_logic;
                  N7 : In    std_logic;
                  N8 : In    std_logic;
                  N9 : In    std_logic;
                  NA : In    std_logic;
                  NB : In    std_logic;
                  P0 : In    std_logic_vector (25 downto 0);
                  P1 : In    std_logic_vector (25 downto 0);
                  P2 : In    std_logic_vector (25 downto 0);
                  P3 : In    std_logic_vector (25 downto 0);
                  P4 : In    std_logic_vector (25 downto 0);
                  P5 : In    std_logic_vector (25 downto 0);
                  P6 : In    std_logic_vector (25 downto 0);
                  P7 : In    std_logic_vector (25 downto 0);
                  P8 : In    std_logic_vector (25 downto 0);
                  P9 : In    std_logic_vector (25 downto 0);
                  PA : In    std_logic_vector (25 downto 0);
                  PB : In    std_logic_vector (25 downto 0);
                  PC : In    std_logic_vector (25 downto 0);
                   C : Out   std_logic_vector (47 downto 0);
                   S : Out   std_logic_vector (47 downto 0) );
end TREE;

architecture SCHEMATIC of TREE is

CONSTANT n : integer := 47;
CONSTANT p : integer := 25;

signal a0 : std_logic_vector (n downto 0);
signal a1 : std_logic_vector (n downto 0);
signal a2 : std_logic_vector (n downto 0);
signal a3 : std_logic_vector (n downto 0);
signal a4 : std_logic_vector (n downto 0);
signal a5 : std_logic_vector (n downto 0);
signal a6 : std_logic_vector (n downto 0);
signal a7 : std_logic_vector (n downto 0);
signal a8 : std_logic_vector (n downto 0);
signal a9 : std_logic_vector (n downto 0);
signal aA : std_logic_vector (n downto 0);
signal aB : std_logic_vector (n downto 0);
signal aC : std_logic_vector (n downto 0);
signal b0 : std_logic_vector (n downto 0);
signal b1 : std_logic_vector (n downto 0);
signal b2 : std_logic_vector (n downto 0);
signal b3 : std_logic_vector (n downto 0);
signal b4 : std_logic_vector (n downto 0);
signal b5 : std_logic_vector (n downto 0);
signal d0 : std_logic_vector (n downto 0);
signal d1 : std_logic_vector (n downto 0);
signal d2 : std_logic_vector (n downto 0);
signal d3 : std_logic_vector (n downto 0);
signal zero : std_logic;

   component gl_csa42 is
        GENERIC(n : integer);
        Port (  A : In std_logic_vector (n downto 0);
                B : In std_logic_vector (n downto 0);
                C : In std_logic_vector (n downto 0);
                D : In std_logic_vector (n downto 0);
                Z : Out std_logic_vector (n downto 0);
                Y : Out std_logic_vector (n downto 0) );
   end component;

   component gl_csa32 is
        GENERIC(n : integer);
        Port (  A : In std_logic_vector (n downto 0);
                B : In std_logic_vector (n downto 0);
                C : In std_logic_vector (n downto 0);
                Cin : In std_logic;
                Z : Out std_logic_vector (n downto 0);
                Y : Out std_logic_vector (n downto 0) );
   end component;

begin

zero<='0';

-- sign extension
a0(n downto p)<=(others => P0(p));
a1(n downto p+2)<=(others => P1(p));
a2(n downto p+4)<=(others => P2(p));
a3(n downto p+6)<=(others => P3(p));
a4(n downto p+8)<=(others => P4(p));
a5(n downto p+10)<=(others => P5(p));
a6(n downto p+12)<=(others => P6(p));
a7(n downto p+14)<=(others => P7(p));
a8(n downto p+16)<=(others => P8(p));
a9(n downto p+18)<=(others => P9(p));
aa(n downto p+20)<=(others => PA(p));
ab(n downto p+22)<=(others => PB(p));

-- assignment
a0(p-1 downto 0) <= P0(p-1 downto 0);
a1(p+1 downto 2) <= P1(p-1 downto 0);  a1(1)<=zero;  a1(0)<=n0;
a2(p+3 downto 4) <= P2(p-1 downto 0);  a2(3)<=zero;  a2(2)<=n1;
a3(p+5 downto 6) <= P3(p-1 downto 0);  a3(5)<=zero;  a3(4)<=n2;
a4(p+7 downto 8) <= P4(p-1 downto 0);  a4(7)<=zero;  a4(6)<=n3;
a5(p+9 downto 10)<= P5(p-1 downto 0);  a5(9)<=zero;  a5(8)<=n4;
a6(p+11 downto 12)<=P6(p-1 downto 0); a6(11)<=zero; a6(10)<=n5;
a7(p+13 downto 14)<=P7(p-1 downto 0); a7(13)<=zero; a7(12)<=n6;
a8(p+15 downto 16)<=P8(p-1 downto 0); a8(15)<=zero; a8(14)<=n7;
a9(p+17 downto 18)<=P9(p-1 downto 0); a9(17)<=zero; a9(16)<=n8;
aa(p+19 downto 20)<=PA(p-1 downto 0); aa(19)<=zero; aa(18)<=n9;
ab(p+21 downto 22)<=PB(p-1 downto 0); ab(21)<=zero; ab(20)<=na;
ac(n downto 24) <= PC(23 downto 0);   ac(23)<=zero; ac(22)<=nb; 

-- LSB bit stuffing

ac(21 downto 0)<=(others => '0');
ab(19 downto 0)<=(others => '0');
aa(17 downto 0)<=(others => '0');
a9(15 downto 0)<=(others => '0');
a8(13 downto 0)<=(others => '0');
a7(11 downto 0)<=(others => '0');
a6(9 downto 0)<=(others => '0');
a5(7 downto 0)<=(others => '0');
a4(5 downto 0)<=(others => '0');
a3(3 downto 0)<=(others => '0');
a2(1 downto 0)<=(others => '0');

A_03 : gl_csa42 Generic Map(n=>n)
        Port Map ( A=> a0, B=> a1, C=> a2, D=> a3, Z=>b0 , Y=>b1);
A_47 : gl_csa42 Generic Map(n=>n)
        Port Map ( A=> a4, B=> a5, C=> a6, D=> a7, Z=>b2 , Y=>b3);
A_8B : gl_csa42 Generic Map(n=>n)
        Port Map ( A=> a8, B=> a9, C=> aa, D=> ab, Z=>b4 , Y=>b5);

B_03 : gl_csa42 Generic Map(n=>n)
        Port Map ( A=> b0, B=> b1, C=> b2, D=> b3, Z=>d0 , Y=>d1);
B_45 : gl_csa32 Generic Map(n=>n)
        Port Map ( A=> b4, B=> b5, C=> ac, cin=>ZERO, Z=>d2 , Y=>d3);


D_03 : gl_csa42 Generic Map(n=>n)
        Port Map ( A=> d0, B=> d1, C=> d2, D=> d3, Z=>S , Y=>C);

end SCHEMATIC;

configuration CFG_TREE_SCHEMATIC of TREE is
   for SCHEMATIC
      for A_03, A_47, A_8B, B_03, D_03 : gl_csa42
         use configuration WORK.CFG_gl_csa42_BEHAVIORAL;
      end for;
      for B_45 : gl_csa32
         use configuration WORK.CFG_gl_csa32_BEHAVIORAL;
      end for;
   end for;

end CFG_TREE_SCHEMATIC;
