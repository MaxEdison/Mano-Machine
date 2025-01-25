library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Comm_bus is
    Port (
        input_0   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_1   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_2   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_3   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_4   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_5   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_6   : in  STD_LOGIC_VECTOR (15 downto 0); 
        input_7   : in  STD_LOGIC_VECTOR (15 downto 0); 
        output    : out STD_LOGIC_VECTOR (15 downto 0); 
        clk       : in  STD_LOGIC;
        DD        : in  STD_LOGIC_VECTOR (7 downto 0);
        T         : in  STD_LOGIC_VECTOR (7 downto 0);
        R         : in  STD_LOGIC;
        I         : in  STD_LOGIC;
        reset     : in  STD_LOGIC 
    );
end Comm_bus;

architecture Behavioral of Comm_bus is
    signal sel_internal : STD_LOGIC_VECTOR(2 downto 0) := "000"; 

    component mux_8to1
        Port (
            sel : in  STD_LOGIC_VECTOR (2 downto 0);
            i   : in  STD_LOGIC_VECTOR (7 downto 0);
            o   : out  STD_LOGIC
        );
    end component;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            sel_internal <= "000"; 
        elsif rising_edge(clk) then
            if (DD(5) = '1' and T(5) = '1') or (DD(4) = '1' and T(4) = '1') then
                sel_internal <= "001";
            elsif (T(0) = '1') or (DD(5) = '1' and T(5) = '1') then
                sel_internal <= "010";
            elsif (DD(2) = '1' and T(5) = '1') or (DD(6) = '1' and T(6) = '1') then
                sel_internal <= "011";
            elsif DD(3) = '1' and T(4) = '1' then
                sel_internal <= "100";
            elsif (not R = '1') and T(2) = '1' then
                sel_internal <= "101";
            elsif R = '1' and T(1) = '1' then
                sel_internal <= "110";
            elsif (not R = '1' and T(1) = '1') or (not DD(2) = '1' and I = '1' and T(3) = '1') or 
                  (DD(0) = '1' and (T(4) = '1' or T(1) = '1')) or (T(4) = '1' and (DD(2) = '1' or DD(6) = '1')) then
                sel_internal <= "111";
            else
                sel_internal <= "000"; 
            end if;
        end if;
    end process;

    gen_mux: for j in 0 to 15 generate
        mux_inst: mux_8to1 port map (
            sel => sel_internal,
            i(0) => input_0(j), i(1) => input_1(j), i(2) => input_2(j), 
            i(3) => input_3(j), i(4) => input_4(j), i(5) => input_5(j), 
            i(6) => input_6(j), i(7) => input_7(j),
            o    => output(j)
        );
    end generate;

end Behavioral;