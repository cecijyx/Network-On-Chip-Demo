------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

---------------------------------------------------------------------------
-- This is an implementation of a testbench of a routing instruction LUT --
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;

entity lut_tb is
end entity lut_tb;

architecture arc of lut_tb is
    component lut is
        port(
            addr : in std_logic_vector(LUT_ADDR_SIZE-1 downto 0);
            inst : out std_logic_vector(RT_INST_SIZE-1 downto 0) 
        );
    end component;
    
    signal address : std_logic_vector(LUT_ADDR_SIZE-1 downto 0) := (others => '0');
    signal instruction : std_logic_vector(RT_INST_SIZE-1 downto 0) := (others => '0');
begin
    lut0 : lut port map(addr => address, inst => instruction);
    
    test : process is
    begin
        wait for 1ns;
        address <= "10000";
        wait for 1ns;
        address <= "00000";
        wait for 1ns;
        address <= "10000";
        wait; -- waits forever, test ends
    end process test;
    
end architecture arc;