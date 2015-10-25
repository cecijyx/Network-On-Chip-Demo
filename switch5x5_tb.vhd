------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

---------------------------------------------------------------------------
-- This is an implementation of a testbench of 8-bit 5x5 crossbar switch --
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;

entity switch5x5_tb is
end entity switch5x5_tb;

architecture arc1 of switch5x5_tb is

    -- declare DUT
    component switch5x5
        port(
            in0, in1, in2, in3, in4      : in std_logic_vector(W-1 downto 0);
            sel0, sel1, sel2, sel3, sel4 : in std_logic_vector(M-1 downto 0);  
            reset, clock                 : in std_logic;
            out0, out1, out2, out3, out4 : out std_logic_vector(W-1 downto 0)
        );
    end component;
    
    -- delcare interconnect signals
    signal din0, din1, din2, din3, din4 : std_logic_vector(W-1 downto 0) := (others => '0');
    signal dout0, dout1, dout2, dout3, dout4 : std_logic_vector(W-1 downto 0) := (others => '0');
    signal s0, s1, s2, s3, s4 : std_logic_vector(M-1 downto 0) := (others => '0');
    signal clk, clr : std_logic := '0';

    -- set clock period to 5ns, f = 500MHz
    signal finished : std_logic := '0';
    constant clk_period : time := 1ns;
begin

    switch : switch5x5 port map(
        in0=>din0, in1=>din1, in2=>din2, in3=>din3, in4=>din4,
        sel0=>s0, sel1=>s1, sel2=>s2, sel3=>s3, sel4=>s4,
        reset=>clr, clock=>clk,
        out0=>dout0, out1=>dout1, out2=>dout2, out3=>dout3, out4=>dout4
    );
    
    -- enables the clock
    clk <= not clk after clk_period/2 when finished /= '1' else '0';
    
    test : process is
        variable error_count : integer := 0;
    begin
        
        -- sets input signals
        din0 <= "00000011";
        din1 <= "00001100";
        din2 <= "00110000";
        din3 <= "11000000";
        din4 <= "00001111";
        
        -- case 1
        clr <= '0';
        s0 <= "000";
        s1 <= "001";
        s2 <= "010";
        s3 <= "011";
        s4 <= "100";
        wait for clk_period * 2;
        if (dout0 /= din0 or dout1 /= din1 or
            dout2 /= din2 or dout3 /= din3 or dout4 /= din4) then
            error_count := error_count + 1;
            assert false report "Testbench: case 1 failed!" severity error;
        end if;
        wait for 5ns;
        
        -- case 2
        clr <= '1'; -- turns on asynchronous reset
        wait for clk_period / 2;
        if (dout0 /= "00000000" or dout1 /= "00000000"
         or dout2 /= "00000000" or dout3 /= "00000000"
         or dout4 /= "00000000") then
            error_count := error_count + 1;
            assert false report "Testbench: case 2 failed!" severity error;
        end if;
        clr <= '0'; -- turns off asynchronous reset
        wait for 5ns;
        
        -- case 3
        s0 <= "100";
        s1 <= "011";
        s2 <= "010";
        s3 <= "001";
        s4 <= "000";
        wait for clk_period * 2;
        if (dout0 /= din4 or dout1 /= din3 
         or dout2 /= din2 or dout3 /= din1 or dout4 /= din0) then
            error_count := error_count + 1;
            assert false report "Testbench: case 3 failed!" severity error;
        end if;
        wait for 5ns;
        
        -- Test summary
        if (error_count = 0) then
            assert false
            report "Testbench of switch4x4 completed successfully!"
            severity note;
        else
            assert false
            report "Test failure, number of errors: " & integer'image(error_count)
            severity error;
        end if;
        
        finished <= '1';
        
        wait;   -- waits forever, test ends
    end process test;
    
end architecture arc1;