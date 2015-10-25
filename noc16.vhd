------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

-- declare a 16-node network-on-chip
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;
entity noc16 is
    -- TO-DO
    generic(w : integer := 8); 
    port(
        n_in, e_in, s_in, w_in, d_in      : in std_logic_vector(w-1 downto 0);
        reset, clock                      : in std_logic;
        n_out, e_out, s_out, w_out, d_out : out std_logic_vector(w-1 downto 0)
    );    
end entity noc16;

architecture behavior of noc16 is
begin
    -- TO-DO
    node0:process(reset,clock) is
    begin
        n_out <= n_in;
    end process node0;
end architecture behavior;