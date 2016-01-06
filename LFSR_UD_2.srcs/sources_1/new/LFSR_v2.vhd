----------------------------------------------------------------------------------
-- Company: University of Obuda
-- Engineer: Tamas Fulop
-- 
-- Create Date: 12/26/2015 03:39:17 PM
-- Design Name: 
-- Module Name: LFSR_v2 - Behavioral
-- Project Name: 
-- Target Devices: Artix 7
-- Tool Versions: 
-- Description: 
--  
--  This design is an implementation of LFSR  with 2 feedback taps. 
--  The width and the tap positions can be set via generics.
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- File writing/logging
USE STD.TEXTIO.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR_v2 is

    Generic (
                width       :   positive    :=  31;
                tap_1       :   positive    :=  30;
                tap_2       :   positive    :=  27                
            );

    Port ( 
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
           
end LFSR_v2;



architecture Behavioral of LFSR_v2 is

signal internal_number  :   std_logic_vector(width -1 downto 0);
signal ghost_clk        :   std_logic;

-- open output file
-- FILE MyFile : TEXT OPEN WRITE_MODE IS "/home/tafulop/generated_numbers_31.txt";
    
begin


    -----------------------------------
    -- Internal number to the output
    -----------------------------------
    o_number <= internal_number; 
    
    
    
    ----------------------------------------------------------------------------
    -- CLOCK SELECTION PROCESS
    --
    -- This process switches between the free running and manual ticking modes.
    ----------------------------------------------------------------------------
    clock_source    :   process(i_clk)
    
    begin
    
        --if(falling_edge(i_clk) or rising_edge(i_clk)) then
            
            if(i_free_run = '1') then
                --o_ghost_clk <= i_clk;
                ghost_clk   <= i_clk;
            else
                --o_ghost_clk <= i_next;
                ghost_clk   <= i_next;
            end if;
                 
        --end if;
    
    end process clock_source;



    -------------------------------------------------------------------------------------------
    -- NUMBER GENERATING PROCESS
    --
    -- In Free Running mode the LFSR switches its state on every rising edge of the i_clk input.
    -- In clocked mode LFSR generates a new number on each clock tick.
    -------------------------------------------------------------------------------------------
    next_number_free_run : process(ghost_clk)
    --variable fileline : line;
    --variable gen_num  : integer;
        
    begin 

        if rising_edge(ghost_clk) then      
            
            --------------------------------------
            -- NORMAL MODE
            -- enable   =   1
            -- reset    =   0
            --------------------------------------
            if (i_enable = '1') then

                -----------------------------
                -- RESET
                -----------------------------
                if(i_reset = '1') then
                    if(i_direction = '1') then
                        internal_number <= (OTHERS => '1');
                    else
                        internal_number <= (OTHERS => '0');
                    end if;  
                else
                    ------------------------------
                    -- LOAD SEED
                    ------------------------------
                    if(i_load = '1') then
                        internal_number <= i_seed;
                    else     
                        --------------------------------------
                        -- GENERATE NEXT NUMBER
                        -------------------------------------                       
                        if(i_direction = '1') then
                            internal_number <= internal_number(width - 2 downto 0) & (internal_number(tap_1) xnor internal_number(tap_2));
                        else
                            internal_number <= internal_number(width - 2 downto 0) & (internal_number(tap_1) xor internal_number(tap_2));
                        end if;
           
                        ----------------------------------------
                        -- FILE LOGGING
                        ----------------------------------------
                        --gen_num := to_integer(internal_number);
                        --write(fileline, gen_num);
                        --writeline(MyFile, fileline); 
                        
                    end if;
                
                end if;   
     
            end if;

        end if;
            
    end process next_number_free_run;
        
end Behavioral;
