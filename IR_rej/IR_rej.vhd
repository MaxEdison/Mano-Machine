library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_rej is
	port(
		R :in std_logic;
		T :in std_logic_vector(7 downto 0);
		CLK :in std_logic;
		IR_in :in std_logic_vector(15 downto 0);
		IR_out :out std_logic_vector(15 downto 0)
		);
end IR_rej;

architecture bhv of IR_rej is
	signal temp: std_logic_vector(15 downto 0);
begin 
	process(CLK)
	begin
	if (rising_edge(CLK)) then 
		if (not(R)='1' and T(1)='1') then 
			temp <= IR_in;
		end if;
	end if;
	end process;
	IR_out <= temp;
end bhv;
