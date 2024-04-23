configuration CFG_TB_fpmul1_BEHAVIORAL of E is
   for A
	 for UUT : fpmul1
	   use configuration WORK.cfg_fpmul1_schematic;
	 end for;

	 for TB
	 end for;

   end for;
end CFG_TB_fpmul1_BEHAVIORAL;

