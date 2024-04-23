library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity PARTPROD is
      GENERIC(n : integer);
      Port (       X : In    std_logic_vector (n-2 downto 0);
                   Y : In    std_logic_vector(2 downto 0);
                 NEG : Out   std_logic;
                   P : Out   std_logic_vector (n downto 0) );
end PARTPROD;

architecture BEHAVIORAL of PARTPROD is

   begin
    process (X, Y)
     variable    pd : std_logic;
     variable    one, two : std_logic;
     variable    z : std_logic_vector (n downto 0);

 begin

  one := y(1) xor y(0);
  two := ((not y(2)) and y(1) and y(0)) or (y(2) and (not y(1)) and (not y(0)));
  -- neg := ap1 and (not(am1 and a));
  -- y(2) is the sign
  NEG <= y(2);

  pd := '0';
  for i in 0 to n-2 loop
     Z(i) := ( one AND X(i) ) OR ( two AND pd ) ;
     pd := X(i);
  end loop;
  Z(n-1) :=  two AND pd;
  Z(n) :=  '0'; -- always positive at this point

  for i in 0 to n loop
	P(i) <= y(2) XOR Z(i);
  end loop;


 end process;

end BEHAVIORAL;

configuration CFG_PARTPROD_BEHAVIORAL of PARTPROD is

   for BEHAVIORAL
   end for;

end CFG_PARTPROD_BEHAVIORAL;
