library IEEE;
	 use IEEE.std_logic_1164.all;

entity fp32mul_pipe is
	Port (	A1 : In std_logic_vector (31 downto 0);
		A2 : In std_logic_vector (31 downto 0);
		CLOCK : In std_logic;
		RESET : In std_logic;
		Z : Out std_logic_vector (31 downto 0) );
end fp32mul_pipe;

architecture SCHEMATIC of fp32mul_pipe is

   signal       BX : std_logic_vector(31 downto 0);
   signal       BY : std_logic_vector(31 downto 0);
   signal       MX : std_logic_vector(23 downto 0);
   signal       MY : std_logic_vector(23 downto 0);
   signal       MZ : std_logic_vector(23 downto 0);
   signal       EXP : std_logic_vector(7 downto 0);
   signal       EXP_pipe : std_logic_vector(7 downto 0);
   signal       EXP1 : std_logic_vector(7 downto 0);
   signal       EXP1_pipe : std_logic_vector(7 downto 0);
   signal       EZ : std_logic_vector(7 downto 0);
   signal       OVF : std_logic;
   signal       SZ : std_logic;
   signal       SZ_pipe : std_logic;


   component reg32b
	Port (	A : In std_logic_vector (31 downto 0);
		CLOCK : In std_logic;
		RESET : In std_logic;
		Z : Out std_logic_vector (31 downto 0) );
   end component;

   component regnb
   Generic (n: integer);
	Port (	A : In std_logic_vector (n-1 downto 0);
		CLOCK : In std_logic;
		RESET : In std_logic;
		Z : Out std_logic_vector (n-1 downto 0) );
   end component;

   component out_sign
        Port (  sX   : In std_logic;
                sY   : In std_logic;
                SZ : Out std_logic );
   end component;

   component expadd
        Port (  A1 : In std_logic_vector (7 downto 0);
                A2 : In std_logic_vector (7 downto 0);
                S : Out std_logic_vector (7 downto 0) );
   end component;

   component expupdate
	Port (  EXP : In std_logic_vector (7 downto 0);
                OVF : In std_logic;
                EZ : Out std_logic_vector (7 downto 0) );
   end component;

   component  expincrement is
        Port (  EXP : In std_logic_vector (7 downto 0);
                EZ : Out std_logic_vector (7 downto 0) );
   end component;

   component significand_compute 
        Port (  MX : In std_logic_vector (23 downto 0);
                MY : In std_logic_vector (23 downto 0);
                OVF : Out std_logic;
                Z : Out std_logic_vector (23 downto 0);
                CLOCK: In std_logic;
                RESET: In std_logic );
   end component;

   component gl_mux21 
        GENERIC(n : integer);
        Port (  A0 : In std_logic_vector (n downto 0);
                A1 : In std_logic_vector (n downto 0);
                SEL : In std_logic;
                Z : Out std_logic_vector (n downto 0) );
   end component;

begin

   REGX : reg32b
	Port Map ( A(31 downto 0)=>A1(31 downto 0), CLOCK=>CLOCK,
		 RESET=>RESET, Z(31 downto 0)=>BX(31 downto 0) );
   REGY : reg32b
	Port Map ( A(31 downto 0)=>A2(31 downto 0), CLOCK=>CLOCK,
		 RESET=>RESET, Z(31 downto 0)=>BY(31 downto 0) );

   EXP_ADD : expadd
	Port Map ( A1(7 downto 0)=>BX(30 downto 23), 
		   A2(7 downto 0)=>BY(30 downto 23),
		   S(7 downto 0)=>EXP_pipe(7 downto 0) ); 
   EXP_INCR : expincrement
	Port Map ( EXP(7 downto 0)=>EXP_pipe(7 downto 0), 
		   EZ(7 downto 0)=>EXP1(7 downto 0) );

   -- must include implicit 1
   MX(23)<='1'; MX(22 downto 0) <= BX(22 downto 0); 
   MY(23)<='1'; MY(22 downto 0) <= BY(22 downto 0); 

   REGPIPE : regnb
   Generic Map (n=>17)
   Port Map (
      A(7 downto 0) => EXP_pipe,
      A(15 downto 8) => EXP1_pipe,
      A(16) => SZ_pipe,
      CLOCK=>CLOCK,
      RESET=>RESET,
      Z(7 downto 0) => EXP,
      Z(15 downto 8) => EXP1,
      Z(16) => SZ
   );

   SIGNIFICAND : significand_compute
	Port Map ( MX=>MX, MY=>MY, OVF=>OVF, Z=>MZ, CLOCK=>CLOCK, RESET=>RESET );

   EXP_MUX : gl_mux21 Generic Map(n=>7)
        Port Map ( A0 => EXP, A1  => EXP1, SEL => OVF, Z => EZ );

   SIGN_COMP : out_sign
	Port Map (  SX=>BX(31), SY=>BY(31), SZ=>SZ_pipe );

   REGZ : reg32b
	Port Map ( A(31)=>SZ,
		   A(30 downto 23)=>EZ(7 downto 0), 
		   A(22 downto 0)=>MZ(22 downto 0), 
		   CLOCK=>CLOCK, RESET=>RESET, 
         Z(31 downto 0)=>Z(31 downto 0) );

end SCHEMATIC;

-- rtl_synthesis off
configuration CFG_fp32mul_pipe_SCHEMATIC of fp32mul_pipe is

   for SCHEMATIC
      for REGX, REGY, REGZ: reg32b
         use configuration WORK.CFG_reg32b_BEHAVIORAL;
      end for;
      for EXP_ADD: expadd
         use configuration WORK.CFG_expadd_BEHAVIORAL;
      end for;
      for SIGNIFICAND: significand_compute
         use configuration WORK.CFG_significand_compute_SCHEMATIC;
      end for;
      for EXP_INCR: expincrement
         use configuration WORK.CFG_expincrement_BEHAVIORAL;
      end for;
      for SIGN_COMP: out_sign 
         use configuration WORK.CFG_out_sign_BEHAVIORAL;
      end for;
      for EXP_MUX : gl_mux21
         use configuration WORK.CFG_gl_mux21_BEHAVIORAL;
      end for;

   end for;

end CFG_fp32mul_pipe_SCHEMATIC;
-- rtl_synthesis on
