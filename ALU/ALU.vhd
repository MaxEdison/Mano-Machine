library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
    port(
        CLK     : in std_logic;
        D       : in std_logic_vector(7 downto 0);
        T       : in std_logic_vector(7 downto 0);
        I       : in std_logic;
        IR      : in std_logic_vector(15 downto 0);
        Cin     : in std_logic;
        input_1 : in std_logic_vector(15 downto 0);
        input_2 : in std_logic_vector(15 downto 0);
        Cout    : out std_logic;
        output  : out std_logic_vector(15 downto 0)
    );
end ALU;

architecture bhv of ALU is
    component C_ALU is 
        port(
            CLK     : in std_logic;
            D       : in std_logic_vector(7 downto 0);
            T       : in std_logic_vector(7 downto 0);
            I       : in std_logic;
            IR      : in std_logic_vector(15 downto 0);
            s_out   : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Arithmetic is 
        port(
            CLK     : in std_logic;
            Cin     : in std_logic;
            select_signal       : in std_logic_vector(1 downto 0);
            input_1 : in std_logic_vector(15 downto 0);
            input_2 : in std_logic_vector(15 downto 0);
            Cout    : out std_logic;
            output  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component Logic is 
        port(
            CLK     : in std_logic;
            s       : in std_logic_vector(1 downto 0);
            input_1 : in std_logic_vector(15 downto 0);
            input_2 : in std_logic_vector(15 downto 0);
            output  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal temp         : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_Arth    : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_Log     : std_logic_vector(15 downto 0) := "0000000000000000";
    signal temp_sel     : std_logic_vector(3 downto 0) := "0000";

begin 

    Contorol : C_ALU port map
        (CLK => CLK,
         D => D,
         T => T,
         I => I,
         IR => IR,
         s_out => temp_sel);
        
    A : Arithmetic port map
        (CLK => CLK, 
         Cin => Cin, 
         select_signal => temp_sel(1 downto 0),
         input_1 => input_1,
         input_2 => input_2,
         Cout => Cout,
         output => temp_Arth);
        
    L : Logic port map 
        (CLK => CLK,
         s => temp_sel(1 downto 0),
         input_1 => input_1,
         input_2 => input_2,
         output => temp_Log);

    process(CLK)
    begin 
        if rising_edge(CLK) then
            case temp_sel(3 downto 2) is
                when "00" => 
                    temp <= temp_Arth; 
                when "01" =>    
                    temp <= temp_Log;
                when "10" =>
                    temp <= std_logic_vector(shift_right(unsigned(input_1), 1)); -- شیفت راست
                when "11" => 
                    temp <= std_logic_vector(shift_left(unsigned(input_1), 1)); -- شیفت چپ
                when others =>
                    temp <= (others => '0');
            end case;
        end if;
    end process;
    

    output <= temp;
end bhv;