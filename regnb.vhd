library IEEE;
	 use IEEE.std_logic_1164.all;

entity regnb is
	GENERIC (N : integer := 32);
	Port (	A : In std_logic_vector (N-1 downto 0);
		CLOCK : In std_logic;
		RESET : In std_logic;
		Z : Out std_logic_vector (N-1 downto 0) );
end regnb;

architecture BEHAVIORAL of regnb is

 begin

   process(clock, reset)
	variable ii: integer;
   begin
     if ( reset = '0' ) then
		for ii in 0 to N-1 loop
			Z(ii) <= '0';
		end loop;
     elsif (( clock = '1' ) and (clock'EVENT)) then
	 Z <= A;
     end if;
   end process;

end BEHAVIORAL;

configuration CFG_REGNB_BEHAVIORAL of regnb is
	for BEHAVIORAL
	end for;
end CFG_regnb_BEHAVIORAL;
