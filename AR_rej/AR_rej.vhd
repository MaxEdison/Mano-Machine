library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AR_rej is
	port(
		R :in std_logic;
		I :in std_logic;
		D :in std_logic_vector(7 downto 0);
		T :in std_logic_vector(7 downto 0);
		CLK :in std_logic;
		AR_in :in std_logic_vector(11 downto 0);
		AR_out :out std_logic_vector(11 downto 0)
		);
end AR_rej;

architecture bhv of AR_rej is
	signal temp: std_logic_vector(11 downto 0);
	signal temp_1: unsigned(11 downto 0);
begin 
	process(CLK)
	begin
	if (rising_edge(CLK)) then 
		if (not(D(7)='1') and I='1' and T(3)='1') or (T(2)='1' and not(R)='1') or (not(R)='1' and T(0)='1') then 
			temp <= AR_in;
		elsif (D(5)='1' and T(4)='1') then 
			temp_1 <= unsigned(AR_in);
			temp <= std_logic_vector(temp_1 + 1);
		elsif (R='1' and T(0)='1') then 
			temp <= (others => '0');
		end if;
	end if;
	end process;
	AR_out <= temp;
end bhv;
