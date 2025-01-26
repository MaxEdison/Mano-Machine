library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
    port(
        CLK   : in std_logic;
        T     : in std_logic_vector(7 downto 0);
        R     : in std_logic;
        Input : in std_logic_vector(7 downto 0)
    );
end Main;

architecture bhv of Main is
    signal E    : std_logic := '0';
    signal I    : std_logic := '0';
    signal D    : std_logic_vector(7 downto 0) := (others => '0');
    signal FGI  : std_logic := '0';
    signal FGO  : std_logic := '0';
    signal IEN  : std_logic := '0';
	signal mem_write_en : std_logic := '0';
    signal IR   : std_logic_vector(15 downto 0) := (others => '0');
    signal TR   : std_logic_vector(15 downto 0) := (others => '0');
    signal output : std_logic_vector(7 downto 0) := (others => '0');
    signal AR   : std_logic_vector(11 downto 0) := (others => '0');
    signal PC   : std_logic_vector(11 downto 0) := (others => '0');
    signal DR   : std_logic_vector(15 downto 0) := (others => '0');
    signal AC   : std_logic_vector(15 downto 0) := (others => '0');
    signal temp_bus : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_address  : std_logic_vector(11 downto 0) := (others => '0');
	signal mem_data_in  : std_logic_vector(15 downto 0) := (others => '0'); 
	signal mem_data_out : std_logic_vector(15 downto 0) := (others => '0'); 
	signal temp_mem : std_logic_vector(15 downto 0) := (others => '0'); 

    component Comm_bus is 
        port(
            input_0   : in  std_logic_vector(15 downto 0); 
            input_1   : in  std_logic_vector(15 downto 0); 
            input_2   : in  std_logic_vector(15 downto 0); 
            input_3   : in  std_logic_vector(15 downto 0); 
            input_4   : in  std_logic_vector(15 downto 0); 
            input_5   : in  std_logic_vector(15 downto 0); 
            input_6   : in  std_logic_vector(15 downto 0); 
            input_7   : in  std_logic_vector(15 downto 0); 
            output    : out std_logic_vector(15 downto 0); 
            clk       : in  std_logic;
            DD        : in  std_logic_vector(7 downto 0);
            T         : in  std_logic_vector(7 downto 0);
            R         : in  std_logic;
            I         : in  std_logic;
            reset     : in  std_logic 
        );
    end component;
    
    component ALU is 
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
    end component;
    
    component AR_rej is 
        port(
            R       : in std_logic;
            I       : in std_logic;
            D       : in std_logic_vector(7 downto 0);
            T       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            AR_in   : in std_logic_vector(11 downto 0);
            AR_out  : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component PC_rej is 
        port(
            R       : in std_logic;
            E       : in std_logic;
            I       : in std_logic;
            D       : in std_logic_vector(7 downto 0);
            T       : in std_logic_vector(7 downto 0);
            IR      : in std_logic_vector(15 downto 0);
            DR      : in std_logic_vector(15 downto 0);
            AC      : in std_logic_vector(15 downto 0);
            FGI     : in std_logic;
            CLK     : in std_logic;
            PC_in   : in std_logic_vector(11 downto 0);
            PC_out  : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component DR_rej is 
        port(
            D       : in std_logic_vector(7 downto 0);
            T       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            DR_in   : in std_logic_vector(15 downto 0);
            DR_out  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component AC_rej is
        port(
            R       : in std_logic;
            E       : in std_logic;
            I       : in std_logic;
            D       : in std_logic_vector(7 downto 0);
            T       : in std_logic_vector(7 downto 0);
            IR      : in std_logic_vector(15 downto 0);
            CLK     : in std_logic;
            AC_in   : in std_logic_vector(15 downto 0);
            AC_out  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component IR_rej is 
        port(
            R       : in std_logic;
            T       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            IR_in   : in std_logic_vector(15 downto 0);
            IR_out  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component TR_rej is 
        port(
            R       : in std_logic;
            T       : in std_logic_vector(7 downto 0);
            CLK     : in std_logic;
            TR_in   : in std_logic_vector(15 downto 0);
            TR_out  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component OUT_rej is 
        port(
            I       : in std_logic;
            T       : in std_logic_vector(7 downto 0);
            D       : in std_logic_vector(7 downto 0);
            IR      : in std_logic_vector(15 downto 0);
            CLK     : in std_logic;
            Out_in  : in std_logic_vector(7 downto 0);
            Out_out : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component decoder is 
        port( 
            i2, i1, i0 : in  std_logic;
            d          : out std_logic_vector(7 downto 0);
            CLK        : in  std_logic;
            T          : in  std_logic_vector(7 downto 0);
            R          : in  std_logic
        );
    end component;
    
begin
    Decode : decoder port map (
        i0 => IR(12),
        i1 => IR(13),
        i2 => IR(14),
        d => D,
        CLK => CLK,
        T => T,
        R => R
    );
    
    reg1 : AR_rej port map (
        R => R,
        I => I,
        D => D,
        T => T,
        CLK => CLK,
        AR_in => temp_bus(11 downto 0),
        AR_out => AR
    );
    
    reg2 : PC_rej port map (
        R => R,
        E => E,
        I => I,
        D => D,
        T => T,
        IR => IR,
        DR => DR,
        AC => AC,
        FGI => FGI,
        CLK => CLK,
        PC_in => temp_bus(11 downto 0),
        PC_out => PC
    );
    
    reg3 : DR_rej port map (
        D => D,
        T => T,
        CLK => CLK,
        DR_in => temp_bus,
        DR_out => DR
    );
    
    reg4 : AC_rej port map (
        R => R,
        E => E,
        I => I,
        D => D,
        T => T,
        IR => IR,
        CLK => CLK,
        AC_in => temp_bus,
        AC_out => AC
    );
    
    reg5 : IR_rej port map (
        R => R,
        T => T,
        CLK => CLK,
        IR_in => temp_bus,
        IR_out => IR
    );
    
    reg6 : TR_rej port map (
        R => R,
        T => T,
        CLK => CLK,
        TR_in => temp_bus,
        TR_out => TR
    );
    
    reg7 : OUT_rej port map (
        I => I,
        D => D,
        T => T,
        IR => IR,
        CLK => CLK,
        Out_in => temp_bus(7 downto 0),
        Out_out => output
    );
    
	Memory_inst : entity work.Memory
    port map (
        CLK      => CLK,
        write_en => mem_write_en,
        address  => mem_address,
        data_in  => mem_data_in,
        data_out => mem_data_out
    );
	
    com_bus : Comm_bus port map (
        input_0 => (others => '0'),
        input_1(11 downto 0) => AR,
        input_1(15 downto 12) => (others => '0'),
        input_2(11 downto 0) => PC,
        input_2(15 downto 12) => (others => '0'),
        input_3 => DR,
        input_4 => AC,
        input_5 => IR,
        input_6 => TR,
        input_7 => mem_data_out,
        output => temp_bus,
        CLK => CLK,
        DD => D,
        T => T,
        I => I,
        R => R,
        reset => '0'
    );
    
    ALU1 : ALU port map (
        CLK => CLK,
        D => D,
        T => T,
        I => I,
        IR => IR,
        Cin => '0',
        input_1 => AC,
        input_2 => DR,
        Cout => E,
        output => AC
    );
    
    process(CLK)
    begin 
        if rising_edge(CLK) then 
            if (not(R)='1' and T(2)='1') then 
                AR <= IR(11 downto 0);
                I <= IR(15);
            end if;
			if (R = '1' and T(1)= '1') or (D(3) = '1' and T(4) = '1') or (D(6) = '1' and T(6) = '1') then
				mem_write_en <= '1';
				mem_address <= AR;
				mem_data_in <= DR;
			else
				mem_write_en <= '0'; 
			end if;
			if (not R = '1' and T(1) = '1') or (not D(2) = '1' and I = '1' and T(3) = '1') or 
                  (D(0) = '1' and (T(4) = '1' or T(1) = '1')) or (T(4) = '1' and (D(2) = '1' or D(6) = '1')) then 
				mem_address <= AR; 
				temp_mem <= mem_data_out; 
			end if;
            if (D(7)='1' and not(I)='1' and T(3)='1' and IR(10)='1') then 
                E <= '0';
            elsif (D(7)='1' and not(I)='1' and T(3)='1' and IR(8)='1') then 
                E <= not(E);
            elsif (D(7)='1' and I='1' and T(3)='1' and IR(11)='1') then 
                FGI <= '0';
            elsif (D(7)='1' and I='1' and T(3)='1' and IR(10)='1') then 
                FGO <= '0';
            elsif (D(7)='1' and I='1' and T(3)='1' and IR(7)='1') then 
                IEN <= '1';
            elsif (D(7)='1' and I='1' and T(3)='1' and IR(6)='1') then 
                IEN <= '0';
            end if;
        end if;
    end process;
end bhv;