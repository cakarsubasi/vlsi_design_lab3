library IEEE;
	 use IEEE.std_logic_1164.all;

entity gl_mux21 is
	GENERIC(n : integer);
	Port (	A0 : In std_logic_vector (n downto 0);
		A1 : In std_logic_vector (n downto 0);
		SEL : In std_logic;
		Z : Out std_logic_vector (n downto 0) );
end gl_mux21;

architecture BEHAVIORAL of gl_mux21 is

 begin
   process(A0, A1, SEL)
   begin
     if ( SEL = '0' ) then
	 Z <= A0;
     else
	 Z <= A1;
     end if;
   end process;

end BEHAVIORAL;

configuration CFG_gl_mux21_BEHAVIORAL of gl_mux21 is
	 for BEHAVIORAL
	 end for;
end CFG_gl_mux21_BEHAVIORAL;
