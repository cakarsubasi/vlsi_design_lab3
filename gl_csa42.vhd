library IEEE;
	 use IEEE.std_logic_1164.all;

entity gl_csa42 is
	GENERIC(n : integer);
	Port (	A : In std_logic_vector (n downto 0);
		B : In std_logic_vector (n downto 0);
		C : In std_logic_vector (n downto 0);
		D : In std_logic_vector (n downto 0);
		Z : Out std_logic_vector (n downto 0);
		Y : Out std_logic_vector (n downto 0) );
end gl_csa42;

architecture BEHAVIORAL of gl_csa42 is

 begin
process(A, B, C, D)
	variable p1 : std_logic_vector (n downto 0) ;
	variable p2 : std_logic_vector (n downto 0) ;
	variable p : std_logic_vector (n downto 0) ;
	variable e : std_logic;
	variable i : integer;
begin

for i in 0 to n loop
	p1(i) := A(i) XOR B(i) ;
	p2(i) := C(i) XOR D(i) ;
	p(i) := p1(i) XOR p2(i) ;
end loop;

e := '0';
Y(0) <= '0';
for i in 0 to n-1 loop
	Z(i) <= p(i) XOR e;
	Y(i+1) <= (e AND p(i)) OR (D(i) AND (NOT p(i)));
	e := (A(i) AND B(i)) OR (A(i) AND C(i)) OR (C(i) AND B(i));
end loop;

Z(n) <= p(n) XOR e ;
end process;
end BEHAVIORAL;

configuration CFG_gl_csa42_BEHAVIORAL of gl_csa42 is
	 for BEHAVIORAL
	 end for;
end CFG_gl_csa42_BEHAVIORAL;
