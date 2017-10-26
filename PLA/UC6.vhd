----------------------------------------------------------------------------------
-- Create Date:    18:25:12 10/20/2017 
-- Design Name: 	8296 UC6 PLA
-- Module Name:    UC6 - Behavioral 
-- Target Devices: xc9536
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: equations taken from http://www.zimmers.net/anonftp/pub/cbm/firmware/computers/pet/8296/324744-1.c
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC6 is

port(	
	A:	in std_logic_vector(15 downto 8);

	PHI2: in std_logic;
	RW: in std_logic;
	NOSCREEN: in std_logic;
	NOIO: in std_logic;
	RAMSELA: in std_logic;
	RAMSEL9: in std_logic;
	RAMON: in std_logic;
	NOROM: in std_logic;
	
	CASENAI: out std_logic;
	FA12: out std_logic;
	CSKB: out std_logic;
	CSE: out std_logic;
	CSIO: out std_logic;
	CSA: out std_logic;
	CS9: out std_logic;
	CSWFF: out std_logic
);

end UC6;

architecture Behavioral of UC6 is

begin


-- write to the $ffxx area (for write access to control register)
-- = $ffxx and write access
-- active high
CSWFF <= '1' when A(15 downto 8) = x"ff" and rw='0' else '0'; 

-- CS9 selects the $9*** ROM socket - no write protection
CS9 <= '0' when A(15 downto 12) = x"9" and (norom='1') and (ramon='1') and (ramsel9='1') else '1'; 

-- CSA selects the $A*** ROM socket - no write protection
CSA <= '0' when A(15 downto 12) = x"a" and norom='1' and ramon='1' and ramsela='1' else '1'; 

-- CSI/O selects the I/O area at $E8**
CSIO <= '0' when (A(15 downto 8) = x"e8") and ((NOIO='1') or (norom='1' and ramon='1') or (norom='1' and ramsela='1')) else '1'; 


-- CSE selects the editor ROM

CSE  <=  '0' when((NOROM='1' and RW='1' and A(12)='0' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1' and 
	      (RAMON='1' or (RAMSEL9='1' and RAMSELA='1'))) or			 
	     (NOROM='1' and RAMON='1' and RW='1' and					 
	      A(8)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or			 
	     (NOROM='0' and NOIO='1' and RW='1' and					 
	      A(8)='1' and A(11)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or		 
	     (NOROM='1' and RAMON='1' and RW='1' and					 
	      A(9)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or			 
	     (NOROM='0' and NOIO='1' and RW='1' and					 
	      A(9)='1' and A(11)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or		 
	     (NOROM='1' and RAMON='1' and RW='1' and					 
	      A(10)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or			 
	     (NOROM='0' and NOIO='1' and RW='1' and					 
	      A(10)='1' and A(11)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or		 
	     (NOROM='1' and RAMSEL9='1' and RAMSELA='1' and RW='1' and			 
	      A(8)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or			 
	     (NOROM='1' and RAMSEL9='1' and RAMSELA='1' and RW='1' and			 
	      A(9)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1') or			 
	     (NOROM='1' and RAMSEL9='1' and RAMSELA='1' and RW='1' and			 
	      A(10)='1' and A(12)='0' and A(13)='1' and A(14)='1' and A(15)='1')) else '1';



-- CSK+B selects the combined Kernel+Basic ROM
CSKB  <= '0' when ((NOROM='1' and RAMON='1' and RW='1' and A(13)='0' and A(14)='1' and A(15)='1') or	 
	     (NOROM='1' and RAMON='1' and RW='1' and A(12)='1' and A(13)='1' and A(15)='1') or	 
	     (NOROM='1' and RAMSELA='1' and RW='1' and A(12)='1' and A(13)='1' and A(14)='1' and A(15)='1')) else '1';

-- FA12 is the highest address bit of the combined BASIC/KERNEL ROM
FA12 <= '0' when NOROM='1' and RAMON='1' and RW='1' and A(15)='1' and (
	   (A(12)='0' and A(13)='0' and A(14)='1') or 	--// $cxxx
	   (A(12)='1' and A(13)='1' and A(14)='0') --// $bxxx
	) else '1';


-- CASENAI is the select signal for "normal" RAM
CASENAI  <= '0' when(Phi2='1' and						
	     (A(15)='0' or						
	      (NOSCREEN='0' and A(12)='0' and A(13)='0' and A(14)='0') or		
	      (NOROM='1' and						
	       ((A(12)='0' and A(13)='0' and A(14)='0') or			
		(RAMSEL9='0' and A(13)='0' and A(14)='0') or			
		(RAMSELA='0' and A(12)='0' and A(14)='0') or			
		(RAMON='0' and A(14)='0') or				
		(RW='0' and A(14)='0') or				
		(RAMON='0' and A(13)='0') or				
		(RW='0' and A(13)='0') or				
		(RW='0' and A(11)='0') or				
		(RAMON='0' and RAMSEL9='0' and A(11)='0' and A(12)='0') or	
		(RAMON='0' and RAMSELA='0' and A(11)='0') or		
		(RAMON='0' and RAMSELA='0' and NOIO='0') or		
		(RW='0' and A(8)='1') or				
		(RAMON='0' and RAMSEL9='0' and A(8)='1' and A(12)='0') or		
		(RAMON='0' and RAMSELA='0' and A(8)='1') or			
		(RW='0' and A(9)='1') or				
		(RAMON='0' and RAMSEL9='0' and A(9)='1' and A(12)='0') or		
		(RAMON='0' and RAMSELA='0' and A(9)='1') or			
		(RW='0' and A(10)='1') or				
		(RAMON='0' and RAMSEL9='0' and A(10)='1' and A(12)='0') or	
		(RAMON='0' and RAMSELA='0' and A(10)='1') or			
		(RW='0' and A(12)='1') or				
		(RAMON='0' and RAMSELA='0' and A(12)='1')))))  else '1';


end Behavioral;

