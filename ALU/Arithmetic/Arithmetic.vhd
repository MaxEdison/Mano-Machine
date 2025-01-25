library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Arithmetic is 
    port(
        CLK     : in std_logic;
        Cin     : in std_logic;
        select_signal : in std_logic_vector(1 downto 0); 
        input_1 : in std_logic_vector(15 downto 0);
        input_2 : in std_logic_vector(15 downto 0);
        Cout    : out std_logic;
        output  : out std_logic_vector(15 downto 0)
    );
end Arithmetic;

architecture bhv of Arithmetic is 
    signal carry_signal : unsigned(16 downto 0) := "00000000000000000";
    signal mux_output : unsigned(15 downto 0) := "0000000000000000";
    signal adder_output : unsigned(15 downto 0) := "0000000000000000";
    signal not_input_2 : unsigned(15 downto 0);
begin 
    not_input_2 <= not(unsigned(input_2));
    carry_signal(0) <= Cin;


    gen_mux: for i in 0 to 15 generate
        MUX : entity work.mux_4to1
            port map (
                CLK => CLK,
                I(0) => input_2(i), 
                I(1) => not_input_2(i), 
                I(2) => '0', 
                I(3) => '1',
                S0 => select_signal(0), 
                S1 => select_signal(1), 
                z => mux_output(i)
            );
    end generate;


    gen_adder: for i in 0 to 15 generate
        FA : entity work.F_A
            port map (
                CLK => CLK, 
                A => input_1(i), 
                B => mux_output(i),
                Cin => carry_signal(i),
                S => adder_output(i), 
                Cout => carry_signal(i+1)
            );
    end generate;


    process(CLK)
    begin
        if rising_edge(CLK) then
            output <= std_logic_vector(adder_output);
            Cout <= carry_signal(16);
        end if;
    end process;
end bhv;