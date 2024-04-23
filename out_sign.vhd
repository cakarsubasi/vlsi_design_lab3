-- ---------------------------------------------------------------
-- File Name : out_sign.vhd
-- Date Created : 02/12/04 at 16:20
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;

entity out_sign is
	Port (	
		sX   : In std_logic;
		sY   : In std_logic;
		SZ : Out std_logic );
end out_sign;

architecture BEHAVIORAL of out_sign is

 begin

 SZ <= sX xor sY;

end BEHAVIORAL;

configuration CFG_out_sign_BEHAVIORAL of out_sign is
	 for BEHAVIORAL
	 end for;
end CFG_out_sign_BEHAVIORAL;
