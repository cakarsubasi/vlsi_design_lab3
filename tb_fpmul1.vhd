library IEEE;
	use IEEE.std_logic_1164.all;
	use STD.textio.all;
	use IEEE.std_logic_textio.all;

entity E is
end E;

architecture A of E is

	 signal A1 : std_logic_vector(31 downto 0);
	 signal A2 : std_logic_vector(31 downto 0);
	 signal CLOCK : std_logic;
	 signal RESET : std_logic;
	 signal  Z : std_logic_vector(31 downto 0);

   component fpmul1
        Port (  A1 : In std_logic_vector (31 downto 0);
                A2 : In std_logic_vector (31 downto 0);
                CLOCK : In std_logic;
                RESET : In std_logic;
                Z : Out std_logic_vector (31 downto 0) );
   end component;

begin

   UUT : fpmul1
	 Port Map ( A1, A2, CLOCK, RESET, Z );

   TB : block
   begin
   process
	file cmdfile: TEXT; 		 -- Define the file 'handle'
	variable line_in,line_out: Line; -- Line buffers
	variable good: boolean;   	 -- Status of the read operations
	variable A,B: std_logic_vector(31 downto 0);
	variable AP,BP: std_logic_vector(31 downto 0);
	variable S: std_logic_vector(31 downto 0);
	variable SP: std_logic_vector(31 downto 0);
	variable operation: std_logic;
	variable opp: std_logic;
	variable c : integer;
	-- constant TEST_PASSED: string := "Test passed:";
	-- constant TEST_FAILED: string := "Test FAILED:";

	begin


  SP := "00000000000000000000000000000000";
  A1 <= "00000000000000000000000000000000";
  A2 <= "00000000000000000000000000000000";
  reset <= '0';
  wait for  5 ns;
  reset <= '1';
  clock <= '0';
  wait for  5 ns;
  c := 1;
-- -------------------------------------------------------------------------
  FILE_OPEN(cmdfile,"testvecs.in",READ_MODE);
  
  loop
    if endfile(cmdfile) then  -- Check EOF
	assert false
	   report "End of file encountered; exiting."
	   severity NOTE;
	exit;
    end if;


if (c > 1) then
    write(line_out, string'("Test "));
    write(line_out,c-1);
    if (Z = SP) then
	write(line_out, string'(" passed:"));
    else
	write(line_out, string'(" FAILED:"));
    end if;
    hwrite(line_out,AP,RIGHT,9);
    write(line_out, string'(" *"));
    hwrite(line_out,BP,RIGHT,9);
    write(line_out, string'(" -> "));
    hwrite(line_out,SP,RIGHT,9);
    if (Z = SP) then
	write(line_out, string'(" =="));
    else
	write(line_out, string'(" <>"));
    end if;
    hwrite(line_out,Z,RIGHT,9);
    writeline(OUTPUT,line_out);     -- write the message
    assert (Z = SP) report "Z does not match in pattern " severity error;
        SP := S;
        AP := A;
        BP := B;
end if;

    readline(cmdfile,line_in);     -- Read a line from the file
    next when line_in'length = 0;  -- Skip empty lines

    hread(line_in,A,good);         -- Read the A argument as hex value
    assert good report "Text I/O read error" severity ERROR;

    hread(line_in,B,good);         -- Read the B argument as hex value
    assert good report "Text I/O read error" severity ERROR;

    hread(line_in,S,good);         -- Read the S argument as hex value
    assert good report "Text I/O read error" severity ERROR;

    A1 <= A;
    A2 <= B;

if (c = 1) then
        SP := S;
        AP := A;
        BP := B;
    readline(cmdfile,line_in);     -- Read a line from the file
    next when line_in'length = 0;  -- Skip empty lines

    hread(line_in,A,good);         -- Read the A argument as hex value
    assert good report "Text I/O read error" severity ERROR;

    hread(line_in,B,good);         -- Read the B argument as hex value
    assert good report "Text I/O read error" severity ERROR;

    hread(line_in,S,good);         -- Read the S argument as hex value
    clock <= '1'; wait for  5 ns; clock <= '0'; wait for  5 ns;

    A1 <= A;
    A2 <= B;
end if;

    clock <= '1'; wait for  5 ns; clock <= '0'; wait for  5 ns;
    c := c + 1;
  end loop;
-- -------------------------------------------------------------------------

  clock <= '1'; wait for  5 ns; clock <= '0'; wait for  5 ns;
  clock <= '1'; wait for  5 ns; clock <= '0'; wait for  5 ns;
  write(line_out, string'("-- END OF SIMULATION -------------------------"));
  writeline(OUTPUT,line_out); 


   end process;
 end block;
end A;

configuration CFG_TB_fpmul1_BEHAVIORAL of E is
   for A
	 for UUT : fpmul1
	   use configuration WORK.cfg_fpmul1_schematic;
	 end for;

	 for TB
	 end for;

   end for;
end CFG_TB_fpmul1_BEHAVIORAL;
