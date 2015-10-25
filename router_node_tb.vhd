------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

---------------------------------------------------------------------------
-- This is an implementation of a testbench of 5x5 switch router node    --
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;

entity router_node_tb is
end entity router_node_tb;

architecture arc of router_node_tb is

    -- declare DUT
    component router_node
        port(
            n_in, e_in, s_in, w_in, d_in      : in std_logic_vector(W-1 downto 0);
            rt_inst_addr                      : in std_logic_vector(
                                                        LUT_ADDR_SIZE-1 downto 0);
            reset, clock                      : in std_logic;
            n_out, e_out, s_out, w_out, d_out : out std_logic_vector(W-1 downto 0)
        );
    end component;
    
    -- delcare interconnect signals
    signal n_in, e_in, s_in, w_in, d_in : std_logic_vector(W-1 downto 0) := (others => '0');
    signal n_out, e_out, s_out, w_out, d_out : std_logic_vector(W-1 downto 0) := (others => '0');
    signal rt_inst_addr : std_logic_vector(LUT_ADDR_SIZE-1 downto 0) := (others => '0');
    signal reset, clock : std_logic := '0';

    -- set clock period to 5ns, f = 500MHz
    signal finished : std_logic := '0';
    constant clk_period : time := 1ns;
begin
    
    node : router_node port map(
        n_in => n_in,
        e_in => e_in,
        s_in => s_in,
        w_in => w_in,
        d_in => d_in,
        rt_inst_addr => rt_inst_addr,
        reset => reset,
        clock => clock,
        n_out => n_out,
        e_out => e_out,
        s_out => s_out,
        w_out => w_out,
        d_out => d_out
    );
    
    -- enables the clock
    clock <= not clock after clk_period/2 when finished /= '1' else '0';
    
    test : process is
        variable error_count : integer := 0;
    begin
        
        -- initializes input data
        n_in <= "00000001";
        e_in <= "00000010";
        s_in <= "00000011";
        w_in <= "00000100";
        d_in <= "00000101";
        
        wait for clk_period;
        
        -- case 1, cyclic-shift test
        rt_inst_addr <= "10000";
        wait for clk_period * 2;
        if( n_out /= d_in or e_out /= n_in or s_out /= e_in
         or w_out /= s_in or d_out /= w_in) then
            error_count := error_count + 1;
            assert false report "Testbench: test case 1 failed!" severity error;
        end if;
        
        -- case 2, input change test
        n_in <= "10000000";
        e_in <= "01111111";
        s_in <= "01111110";
        w_in <= "01111101";
        d_in <= "01111100";
        wait for clk_period * 2;
        if( n_out /= d_in or e_out /= n_in or s_out /= e_in
         or w_out /= s_in or d_out /= w_in) then
            error_count := error_count + 1;
            assert false report "Testbench: test case 2 failed!" severity error;
        end if;
        
        -- case 3, reset test
        reset <= '1';
        wait for clk_period * 2;
        if( n_out /= "00000000" or e_out /= "00000000" or s_out /= "00000000"
         or w_out /= "00000000" or d_out /= "00000000") then
            error_count := error_count + 1;
            assert false report "Testbench: test case 3 failed!" severity error;
        end if;
        
        -- Test summary
        if (error_count = 0) then
            assert false
            report "Testbench of router_node completed successfully!"
            severity note;
        else
            assert false
            report "Test failure, number of errors: " & integer'image(error_count)
            severity error;
        end if;
    
        wait;   -- waits forever, test ends
    end process test;
end architecture arc;
