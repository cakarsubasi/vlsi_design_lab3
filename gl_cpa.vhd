library IEEE;
	 use IEEE.std_logic_1164.all;

entity gl_cpa    is
	GENERIC(n : integer);
	Port (	A1 : In std_logic_vector (n downto 0);
		A2 : In std_logic_vector (n downto 0);
		S : Out std_logic_vector (n downto 0) );
end gl_cpa;

architecture BEHAVIORAL of gl_cpa is

 begin
process(A1, A2)
	variable p : std_logic_vector (n downto 0) ;
	variable g : std_logic_vector (n downto 0) ;
	variable c : std_logic_vector (n downto 0) ;
	variable i : integer;
begin

c(0) := '0';
for i in 0 to n loop
	p(i) := A1(i) XOR A2(i) ;
	g(i) := A1(i) AND A2(i) ;
end loop;

-- CARRY (ripple) --------------------------
for i in 0 to (n-1) loop
	c(i+1) := g(i) OR (c(i) AND p(i));
end loop;

-- SUM -------------------------------------
for i in 0 to n loop
  S(i) <= p(i) XOR c(i);
end loop;

end process;
end BEHAVIORAL;

configuration CFG_gl_cpa_BEHAVIORAL of gl_cpa    is
	 for BEHAVIORAL
	 end for;
end CFG_gl_cpa_BEHAVIORAL;
