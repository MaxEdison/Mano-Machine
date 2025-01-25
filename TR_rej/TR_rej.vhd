library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TR_rej is
	port(
		R :in std_logic;
		T :in std_logic_vector(7 downto 0);
		CLK :in std_logic;
		TR_in :in std_logic_vector(15 downto 0);
		TR_out :out std_logic_vector(15 downto 0)
		);
end TR_rej;

architecture bhv of TR_rej is
	signal temp: std_logic_vector(15 downto 0);
begin 
	process(CLK)
	begin
	if (rising_edge(CLK)) then 
		if (R='1' and T(0)='1') then
			temp <= TR_in;
		end if;
	end if;
	end process;
	TR_out <= temp;
end bhv;
