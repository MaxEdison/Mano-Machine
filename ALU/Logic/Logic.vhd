library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Logic is
    port(
        CLK     : in std_logic;
        s       : in std_logic_vector(1 downto 0);
        input_1 : in std_logic_vector(15 downto 0);
        input_2 : in std_logic_vector(15 downto 0);
        output  : out std_logic_vector(15 downto 0)
    );
end Logic;

architecture bhv of Logic is
    signal temp : unsigned(15 downto 0);
    signal temp_and : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_or : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_xor : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_not : std_logic_vector(15 downto 0) := "0000000000000000";
begin
    temp_and <= input_1 and input_2;
    temp_or <= input_1 or input_2;
	temp_xor <= input_1 xor input_2;
	temp_not <= not(input_1);
    gen_logic: for i in 0 to 15 generate
        mux_inst : entity work.mux_4to1
        port map (
            CLK => CLK, 
            I(0) => temp_and(i),
            I(1) => temp_or(i),
            I(2) => temp_xor(i),
            I(3) => temp_not(i),
            S0 => s(0),
            S1 => s(1),
            z => temp(i)
        );
    end generate;


    output <= std_logic_vector(temp);
end bhv;
