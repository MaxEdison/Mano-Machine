library ieee;
use ieee.std_logic_1164.all;

entity F_A is
    port (
        CLK : in std_logic;
        A, B, Cin : in std_logic;
        S, Cout : out std_logic
    );
end F_A;

architecture bhv of F_A is
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            S <= A xor B xor Cin;
            Cout <= (A and B) or (Cin and (A xor B));
        end if;
    end process;
end bhv;