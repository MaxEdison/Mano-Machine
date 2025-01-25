library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Out_rej is
	port(

		I :in std_logic;
		T :in std_logic_vector(7 downto 0);
		D :in std_logic_vector(7 downto 0);
		IR :in std_logic_vector(15 downto 0);
		CLK :in std_logic;
		Out_in :in std_logic_vector(7 downto 0);
		Out_out :out std_logic_vector(7 downto 0)
		);
end Out_rej;

architecture bhv of Out_rej is
	signal temp: std_logic_vector(7 downto 0);
	signal p: std_logic;
begin 
	process(CLK)
	begin
	p <= (D(7) and I and T(3));
	if (rising_edge(CLK)) then 
		if (p='1' and IR(10)='1') then
			temp <= Out_in;
		end if;
	end if;
	end process;
	Out_out <= temp;
end bhv;
