------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

---------------------------------------------------------------------------
-- This is an implementation of a 8-bit circuit switch router node       --
---------------------------------------------------------------------------

-- declare lookup table to store routing-instructions for the switch
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;

entity lut is
    port(
        addr : in std_logic_vector(LUT_ADDR_SIZE-1 downto 0);
        inst : out std_logic_vector(RT_INST_SIZE-1 downto 0) 
    );
end entity lut;

architecture arc of lut is
begin
    -- "cyclic-shift" instruction
    inst <= "0000001100000010000000010000000000000100" when addr = "10000" else
            (RT_INST_SIZE-1 downto 0 => 'X');
end architecture arc;

-- declare a router node
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
use work.all;
entity router_node is
    port(
        n_in, e_in, s_in, w_in, d_in      : in std_logic_vector(W-1 downto 0);
        rt_inst_addr                      : in std_logic_vector(
                                                    LUT_ADDR_SIZE-1 downto 0);
        reset, clock                      : in std_logic;
        n_out, e_out, s_out, w_out, d_out : out std_logic_vector(W-1 downto 0)
    );
end entity router_node;

architecture behavior of router_node is
    -- declare interconnect wires
    signal rt_inst  : std_logic_vector(RT_INST_SIZE-1 downto 0);
           
    -- declare routing instructions lookup-table
    component lut is
        port(
            addr : in std_logic_vector(LUT_ADDR_SIZE-1 downto 0);
            inst : out std_logic_vector(RT_INST_SIZE-1 downto 0) 
        );
    end component;
    
    -- declare 5x5 circuit switch
    component switch5x5 is
        port(
            in0, in1, in2, in3, in4      : in std_logic_vector(W-1 downto 0);
            sel0, sel1, sel2, sel3, sel4 : in std_logic_vector(M-1 downto 0);  
            reset, clock                 : in std_logic;
            out0, out1, out2, out3, out4 : out std_logic_vector(W-1 downto 0)
        );
    end component;
begin

    -- instantiates a LUT
    inst_lut : lut port map(addr => rt_inst_addr, inst => rt_inst);
    
    -- instantiates a 5x5 switch
    switch55 : switch5x5 port map(
        in0 => n_in,
        in1 => e_in,
        in2 => s_in,
        in3 => w_in,
        in4 => d_in,
        sel0 => rt_inst(2 downto 0),
        sel1 => rt_inst(10 downto 8),
        sel2 => rt_inst(18 downto 16),
        sel3 => rt_inst(26 downto 24),
        sel4 => rt_inst(34 downto 32),
        reset => reset,
        clock => clock,
        out0 => n_out,
        out1 => e_out,
        out2 => s_out,
        out3 => w_out,
        out4 => d_out
    );
    
end architecture behavior;
