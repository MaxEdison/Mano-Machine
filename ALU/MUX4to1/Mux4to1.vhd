library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity mux_4to1 is
 port(

	CLK :in STD_LOGIC;
    I : in STD_LOGIC_vector(3 downto 0);
    S0 : in STD_LOGIC;
    S1 : in STD_LOGIC;
	Z: out STD_LOGIC
	
  );
end mux_4to1;

architecture bhv of mux_4to1 is
begin
process (CLK) is
	begin
	if (rising_edge(CLK)) then 
		if (S0 ='0' and S1 = '0') then
			Z <= I(0);
		elsif (S0 ='1' and S1 = '0') then
			Z <= I(1);
		elsif (S0 ='0' and S1 = '1') then
			Z <= I(2);
		else
			Z <= I(3);
		end if;
	end if;
	
end process;
end bhv;