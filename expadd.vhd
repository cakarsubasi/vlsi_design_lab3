library IEEE;
	 use IEEE.std_logic_1164.all;

entity expadd is
	Port (	A1 : In std_logic_vector (7 downto 0);
		A2 : In std_logic_vector (7 downto 0);
		S : Out std_logic_vector (7 downto 0) );
end expadd;

architecture BEHAVIORAL of expadd is

 begin
process(A1, A2)
	CONSTANT m : std_logic_vector (7 downto 0) := "10000001" ;
	variable s1, s2  : std_logic_vector (7 downto 0) ;
	variable p0, p1, g0 : std_logic_vector (7 downto 0) ;
	variable c0    : std_logic_vector (8 downto 0) ;
	variable d1, d2, sign: std_logic;
	variable i : integer;
begin

for i in 0 to 7 loop
  p0(i) := a1(i) xor a2(i);
  g0(i) := a1(i) and a2(i);
end loop;

c0(0) := '0';
for i in 0 to 7 loop
  p1(i) := m(i) xor p0(i);
  c0(i+1) := (m(i) and p0(i)) or g0(i);
end loop;

-------- sum a1+a2-m  -----------------------------------------------
d2 := '0';
for i in 0 to 7 loop
  s2(i) := p1(i) XOR c0(i) XOR d2;
  d2 := ( p1(i) AND c0(i) ) OR ( p1(i) AND d2 ) OR ( d2 AND c0(i) ) ;
end loop;

--------------------------------------------------------------
S <= s2;

end process;
end BEHAVIORAL;

configuration CFG_expadd_BEHAVIORAL of expadd is
	 for BEHAVIORAL
	 end for;
end CFG_expadd_BEHAVIORAL;
