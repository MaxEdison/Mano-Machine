library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    Port(
		i2, i1, i0 : in  STD_LOGIC;
        d : out  STD_LOGIC_vector(7 downto 0);
		CLK :in std_logic;
		T : in std_logic_vector(7 downto 0);
		R : in std_logic
		);
end decoder;

architecture Behavioral of decoder is
begin
    process(i2, i1, i0)
    begin
		if rising_edge(clk) then
			if (not(R)='1' and T(2)='1') then 
				if i2 = '0' and i1 = '0' and i0 = '0' then
					d <= "00000001";
				elsif i2 = '0' and i1 = '0' and i0 = '1' then
					d <= "00000010";
				elsif i2 = '0' and i1 = '1' and i0 = '0' then
					d <= "00000100";
				elsif i2 = '0' and i1 = '1' and i0 = '1' then
					d <= "00001000";
				elsif i2 = '1' and i1 = '0' and i0 = '0' then
					d <= "00010000";
				elsif i2 = '1' and i1 = '0' and i0 = '1' then
					d <= "00100000";
				elsif i2 = '1' and i1 = '1' and i0 = '0' then
					d <= "01000000";
				else
					d <= "10000000";
				end if;
			end if;
		end if;
    end process;
end Behavioral;
