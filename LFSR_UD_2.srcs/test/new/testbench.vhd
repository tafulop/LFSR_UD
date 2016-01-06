library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;


----------------------------------------------------------------------------------


entity testbench is
end testbench;


----------------------------------------------------------------------------------


architecture behavioral of testbench is


    ------------------------------------------------------------------------------
    -- Constant Declarations
    ------------------------------------------------------------------------------

    -- Simulation clock period
    constant clk_period     :   time        := 10 ns;
    constant width          :   positive    := 31;


    ------------------------------------------------------------------------------
    -- Signal Declarations
    ------------------------------------------------------------------------------

    signal s_enable     :   std_logic;
    signal s_reset      :   std_logic;
    signal s_clk        :   std_logic;
    
    signal s_next       :   std_logic;
    signal s_free_run   :   std_logic;
    signal s_load       :   std_logic;
    signal s_direction  :   std_logic;
    
    --signal s_ghost_clk  :   std_logic;
    
    signal s_number     :   std_logic_vector(width -1  downto 0);
    signal s_seed       :   std_logic_vector(width -1 downto 0);
    
    ------------------------------------------------------------------------------
    -- Component Declarations
    ------------------------------------------------------------------------------

    component LFSR_v2
        Port    ( 
                   i_enable     :   in    std_logic;
                   i_reset      :   in    std_logic;
                   i_clk        :   in    std_logic;
                   
                   i_next       :   in    std_logic;
                   i_free_run   :   in    std_logic;
                   i_load       :   in    std_logic;
                   i_direction  :   in    std_logic;
                   
                   --o_ghost_clk  :   out   std_logic;      
                   o_number     :   out   std_logic_vector (width -1 downto 0);
                   i_seed       :   in    std_logic_vector (width -1 downto 0)      
                   
                );
    end component LFSR_v2;


begin


    ------------------------------------------------------------------------------
    --  Instance of LFSR
    ------------------------------------------------------------------------------
    inst_LFSR_v2 : LFSR_v2
    port map (
        i_enable    =>  s_enable,
        i_reset     =>  s_reset,
        i_clk       =>  s_clk,
        
        i_next      =>  s_next,
        i_free_run  =>  s_free_run,
        i_load      =>  s_load,
        i_direction =>  s_direction,
        
        --o_ghost_clk =>  s_ghost_clk,
        o_number    =>  s_number,
        i_seed      =>  s_seed
    );
    
   

    ------------------------------------------------------------------------------
    --  Clock generator
    --
    --  Process
    ------------------------------------------------------------------------------
    proc_clk_gen : process
    begin
        s_clk <= '0'; wait for clk_period / 2;
        s_clk <= '1'; wait for clk_period / 2;
    end process proc_clk_gen;


    ------------------------------------------------------------------------------
    --  Stimulus
    --
    --    signal s_enable     :   std_logic;
    --    signal s_reset      :   std_logic;
    --    signal s_clk        :   std_logic;
    --    
    --    signal s_next       :   std_logic;
    --    signal s_free_run   :   std_logic;
    --    signal s_load       :   std_logic;
    --    signal s_direction  :   std_logic;
    --
    --
    --  Process
    ------------------------------------------------------------------------------
    proc_stimulus: process
    begin

        ----------------------------
        -- TEST SEED INIT
        ----------------------------

            -- ENABLE OFF -> SEED SHOULD NOT BE INITIALIZED
            s_enable    <=  '0';
            s_reset     <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '1';
            s_next      <=  '0';
            s_direction <=  '0';
            
            s_seed   <=  (OTHERS => '1');
            wait for 5 ns;

            -- ENABLE ON -> SEED SHOULD BE INITIALIZED
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '1';
            s_direction <=  '0';
            s_seed   <=  (OTHERS => '0');
            wait for 8 ns;
            
            -- ENABLE ON -> SEED SHOULD BE INITIALIZED
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '1';
            s_direction <=  '0';
            s_seed   <=  (OTHERS => '1');
            wait for 8 ns;
            
            
        ----------------------------
        -- TEST FREE RUNNING UP COUNT
        ---------------------------- 
            
            -- Init seed to 0x00
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '1';
            s_direction <=  '1';
            s_seed   <=  (OTHERS => '0');
            wait for 10 ns;
            
            -- Start
            s_load      <=  '0';
            wait for 1000 ns;
            
        ----------------------------
        -- TEST RESET UP COUNT
        ---------------------------- 
            
            -- Init seed to max value
            s_enable    <=  '1';
            s_reset     <=  '1'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '0';
            s_direction <=  '1';
            s_seed   <=  (OTHERS => '1');
            wait for 50 ns;               
            
        ----------------------------
        -- TEST FREE RUNNING DOWN COUNT
        ---------------------------- 
            
            -- Init seed to max value
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '1';
            s_direction <=  '0';
            s_seed   <=  (OTHERS => '1');
            wait for 10 ns;   
            
            -- Start
            s_load      <=  '0';
            wait for 1000 ns;

        ----------------------------
        -- TEST RESET DOWN COUNT
        ---------------------------- 
            
            -- Init seed to max value
            s_enable    <=  '1';
            s_reset     <=  '1'; 
            s_next      <=  '0';
            s_free_run  <=  '1';
            s_load      <=  '0';
            s_direction <=  '0';
            s_seed   <=  (OTHERS => '1');
            wait for 50 ns;    
            
            
            
        ----------------------------
        -- TEST MANUAL RUNNING UP COUNT
        ---------------------------- 
            
            -- Init seed to 0x00
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';    -- free running until the seed has been loaded    
            s_load      <=  '1'; 
            s_direction <=  '1';
            s_seed   <=  (OTHERS => '0');
            wait for 10 ns;
    
            -- switch to manual mode
            s_free_run  <=  '0';
            s_load      <=  '0';
   
   
            -- Drive manually
            for i in 0 to 20 loop
                
                s_next      <=  '1';
                wait for clk_period /2;
                s_next      <=  '0';
                wait for clk_period /2;
                
            end loop;

        ----------------------------
        -- TEST MANUAL RUNNING DOWN COUNT
        ---------------------------- 
            
            -- Init seed to 0x00
            s_enable    <=  '1';
            s_reset     <=  '0'; 
            s_next      <=  '0';
            s_free_run  <=  '1';    -- free running until the seed has been loaded    
            s_load      <=  '1'; 
            s_direction <=  '0';
            s_seed   <=  (OTHERS => '0');
            wait for 10 ns;
    
            -- switch to manual mode
            s_free_run  <=  '0';
            s_load      <=  '0';
   
            -- Drive manually
            for i in 0 to 20 loop
                
                s_next      <=  '1';
                wait for clk_period /2;
                s_next      <=  '0';
                wait for clk_period /2;
                
            end loop;
        
        
        -----------------------------------
        -- Final reset
        -----------------------------------
        s_reset     <=  '1';
        
        
    end process proc_stimulus;


end behavioral;