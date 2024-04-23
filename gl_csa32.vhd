library IEEE;
	 use IEEE.std_logic_1164.all;

entity gl_csa32 is
	GENERIC(n : integer);
	Port (	A : In std_logic_vector (n downto 0);
		B : In std_logic_vector (n downto 0);
		C : In std_logic_vector (n downto 0);
		Cin : In std_logic;
		Z : Out std_logic_vector (n downto 0);
		Y : Out std_logic_vector (n downto 0) );
end gl_csa32;

architecture BEHAVIORAL of gl_csa32 is

 begin
process(A, B, C, Cin)
	variable p : std_logic_vector (n downto 0) ;
	variable g : std_logic_vector (n downto 0) ;
	variable i : integer;
begin

for i in 0 to n loop
	p(i) := A(i) XOR B(i) ;
	g(i) := A(i) AND B(i) ;
end loop;

-- CARRY -----------------------------------
Y(0) <= Cin;
for i in 0 to n-1 loop
	Y(i+1) <= g(i) OR (c(i) AND p(i));
end loop;

-- SUM -------------------------------------
for i in 0 to n loop
	Z(i) <= p(i) XOR c(i);
end loop;

end process;
end BEHAVIORAL;

configuration CFG_gl_csa32_BEHAVIORAL of gl_csa32 is
	 for BEHAVIORAL
	 end for;
end CFG_gl_csa32_BEHAVIORAL;
