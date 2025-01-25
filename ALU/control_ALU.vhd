library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity C_ALU is 
	port(
		CLK : in std_logic;
		D : in std_logic_vector(7 downto 0);
		T : in std_logic_vector(7 downto 0);
		I : in std_logic;
		IR : in std_logic_vector(15 downto 0);
		s_out :out std_logic_vector(3 downto 0)
		);
end C_ALU;

architecture bhv of C_ALU is 
	signal temp_sel:std_logic_vector(3 downto 0);
	signal rr :std_logic;
	signal p :std_logic;
begin 
	rr <= (D(7) and not(I) and T(3));
	p <= (D(7) and I and T(3));
	process(CLK)
	begin
		if (D(1)='1' and T(5)='1') then 
			temp_sel <= "0000";
		elsif(D(0)='1' and T(5)='1') then 
			temp_sel <= "0100";
		elsif(rr='1' and (IR(9)='1' or IR(10)='1')) then 
			temp_sel <= "0111";
		elsif(rr='1' and IR(7)='1') then 
			temp_sel(3 downto 2) <= "10";
		elsif(rr='1' and IR(6)='1') then
			temp_sel(3 downto 2) <= "11";
		end if;
	end process;
	s_out <= temp_sel;
 end bhv;

