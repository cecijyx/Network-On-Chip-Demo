------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

package constants_pkg is
    -- define constants
    constant W             : integer := 8; -- Data bus width
    constant M             : integer := 3; -- number of bits of each Mux control
    constant LUT_ADDR_SIZE : integer := 5; -- Number of bits of a LUT address
    constant RT_INST_SIZE  : integer := 5 * 8; -- Routing instruction size
end;