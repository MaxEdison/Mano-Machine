library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity mux_8to1 is
    Port ( 
        sel : in  STD_LOGIC_VECTOR (2 downto 0);
        i   : in  STD_LOGIC_VECTOR (7 downto 0);
        o   : out  STD_LOGIC
    );
end mux_8to1;

architecture Behavioral of mux_8to1 is
begin
    process(sel, i)
    begin
        if sel = "000" then
            o <= i(0);
        elsif sel = "001" then
            o <= i(1);
        elsif sel = "010" then
            o <= i(2);
        elsif sel = "011" then
            o <= i(3);
        elsif sel = "100" then
            o <= i(4);
        elsif sel = "101" then
            o <= i(5);
        elsif sel = "110" then
            o <= i(6);
        elsif sel = "111" then
            o <= i(7);
        end if;
    end process;
end Behavioral;
