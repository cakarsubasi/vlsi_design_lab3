-- ---------------------------------------------------------------
-- File Name : expupdate.vhd
-- Date Created : 02/12/04 at 16:20
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;

entity expupdate is
	Port (	EXP : In std_logic_vector (7 downto 0);
		OVF : In std_logic;
		EZ : Out std_logic_vector (7 downto 0) );
end expupdate;

architecture BEHAVIORAL of expupdate is

 begin
process(EXP, OVF)
	variable carry : std_logic;
	variable sub : std_logic_vector (7 downto 0);
	variable i : integer;
begin

if (OVF = '1') then
 carry := '1';
 for i in 0 to 7 loop
  EZ(i) <= EXP(i) XOR carry;
  carry := EXP(i) AND carry;
 end loop;
else
 EZ <= EXP;
end if;

end process;
end BEHAVIORAL;

configuration CFG_expupdate_BEHAVIORAL of expupdate is
	 for BEHAVIORAL
	 end for;
end CFG_expupdate_BEHAVIORAL;
