library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port(
        CLK      : in std_logic;
        write_en : in std_logic; 
        address  : in std_logic_vector(11 downto 0); 
        data_in  : in std_logic_vector(15 downto 0); 
        data_out : out std_logic_vector(15 downto 0)
    );
end Memory;

architecture bhv of Memory is
    type mem_type is array (0 to 4095) of std_logic_vector(15 downto 0); 
    signal mem : mem_type := (others => (others => '0'));
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if write_en = '1' then 
                mem(to_integer(unsigned(address))) <= data_in;
            end if;
            data_out <= mem(to_integer(unsigned(address))); 
        end if;
    end process;
end bhv;