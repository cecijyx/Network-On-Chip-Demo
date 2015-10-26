------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------
library ieee;
use ieee.std_logic_1164.all;
package constants_pkg is
    -- define constants
    constant W            : integer := 8; -- Data bus width
    constant M            : integer := 3; -- number of bits of each Mux control
    constant ADDR_SIZE    : integer := 5; -- Number of bits of a LUT address
    constant RT_INST_SIZE : integer := 5 * 8; -- Routing instruction size
    constant NOC_SIZE     : integer := 16; -- Number of router nodes of NOC
    subtype data_bus is std_logic_vector(W-1 downto 0); -- interconnect data bus
    type data_bus_array is array(0 to NOC_SIZE-1) of data_bus;
end;