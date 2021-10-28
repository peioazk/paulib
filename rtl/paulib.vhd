--+--------------------------------------------------------------------------------------------------------------------+
--|  File: paulib.vhd
--|  Project: paulib
--|  Description: VHDL basic components package.
--|
--+--------------------------------------------------------------------------------------------------------------------+

--+-----------------------------------------------------------------------------+
--|							PACKAGE COMPONENTS DECLARATION						|
--+-----------------------------------------------------------------------------+
library ieee;
use ieee.std_logic_1164.all;

package paulib_pkg is
	component rep0
	port (
		clk_i  : in std_logic;
		arst_i : in std_logic;
        a_i    : in std_logic;
    	y_o    : out std_logic
	);
	end component;

    component rep
	port (
		clk_i  : in std_logic;
		arst_i : in std_logic;
        a_i    : in std_logic;
    	y_o    : out std_logic
	);
	end component;

    component cnt
	    generic (size : integer := 8);
	port (
		clk_i  : in std_logic;
		arst_i : in std_logic;
        en_i   : in std_logic;
    	q_o    : out std_logic_vector(size-1 downto 0)
	);
	end component;

end paulib_pkg;

--+-----------------------------------------------------------------------------+
--|								ENTITY & ARCHITECTURE							|
--+-----------------------------------------------------------------------------+
--+-----------------------------------------+
--|  rep0									|
--+-----------------------------------------+
-- Rising Edge Pulse w/o synchronization
library ieee;
use ieee.std_logic_1164.all;

entity rep0 is
port (
	clk_i  : in std_logic;
	arst_i : in std_logic;
    a_i    : in std_logic;
   	y_o    : out std_logic
);
end rep0;

architecture rtl of rep0 is
	signal a_s	: std_logic;
begin
	REP0_P: process(clk_i, arst_i)
	begin
		if (arst_i = '1') then
			a_s  <= '0';
        elsif (rising_edge(clk_i) ) then
			a_s  <= a_i;
		end if;
	end process REP0_P;
    --
	y_o <= a_i and (not a_s);
end rtl;

--+-----------------------------------------+
--|  rep									|
--+-----------------------------------------+
-- Rising Edge Pulse
library ieee;
use ieee.std_logic_1164.all;

entity rep is
port (
	clk_i  : in std_logic;
	arst_i : in std_logic;
    a_i    : in std_logic;
   	y_o    : out std_logic
);
end rep;

architecture rtl of rep is
	signal a_s	: std_logic;
    signal a_s2	: std_logic;
begin
	REP_P: process(clk_i, arst_i)
	begin
		if (arst_i = '1') then
			a_s  <= '0';
            a_s2  <= '0';
        elsif (rising_edge(clk_i) ) then
			a_s  <= a_i;
            a_s2  <= a_s;
		end if;
	end process REP_P;
    --
	y_o <= a_s and (not a_s2);
end rtl;

--+-----------------------------------------+
--|  rep									|
--+-----------------------------------------+
-- Counter with enable
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cnt is
	generic(size : integer := 8);
port (
	clk_i  : in std_logic;
	arst_i : in std_logic;
    en_i   : in std_logic;
   	q_o    : out std_logic_vector(size-1 downto 0)
);
end cnt;

architecture rtl of cnt is
begin
	CNT_P: process(clk_i, arst_i, en_i)
        variable iq : std_logic_vector(size-1 downto 0) := (others => '0');
	begin
	    if (arst_i = '1') then
    		iq := (others => '0');
        elsif (rising_edge(clk_i)) then
            if (en_i = '1') then
                iq := iq + 1;
            end if;
    	end if;
        q_o <= iq;
    end process CNT_P;
end rtl;
