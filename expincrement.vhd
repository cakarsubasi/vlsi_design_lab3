-- ---------------------------------------------------------------
-- File Name : expupdate.vhd
-- Date Created : 02/12/04 at 16:20
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;

entity expincrement is
	Port (	EXP : In std_logic_vector (7 downto 0);
		EZ : Out std_logic_vector (7 downto 0) );
end expincrement;

architecture BEHAVIORAL of expincrement is

 begin
process(EXP)
	variable carry : std_logic;
	variable i : integer;
begin

 carry := '1';
 for i in 0 to 7 loop
  EZ(i) <= EXP(i) XOR carry;
  carry := EXP(i) AND carry;
 end loop;

end process;
end BEHAVIORAL;

configuration CFG_expincrement_BEHAVIORAL of expincrement is
	 for BEHAVIORAL
	 end for;
end CFG_expincrement_BEHAVIORAL;
