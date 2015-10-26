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
    port(
        din0, din1, din2, din3,
        din4, din5, din6, din7,
        din8, din9, din10,din11,
        din12,din13,din14,din15     : in std_logic_vector(W-1 downto 0);
        address                     : in std_logic_vector(ADDR_SIZE-1 downto 0);                 
        reset, clock                : in std_logic;
        dout0, dout1, dout2, dout3,
        dout4, dout5, dout6, dout7,
        dout8, dout9, dout10,dout11,
        dout12,dout13,dout14,dout15 : out std_logic_vector(w-1 downto 0)
    );    
end entity noc16;

architecture cyclic_network of noc16 is
    component router_node is
        port(
            n_in, e_in, s_in, w_in, d_in      : in std_logic_vector(W-1 downto 0);
            rt_inst_addr                      : in std_logic_vector(
                                                            ADDR_SIZE-1 downto 0);
            reset, clock                      : in std_logic;
            n_out, e_out, s_out, w_out, d_out : out std_logic_vector(W-1 downto 0)
        );
    end component router_node;
    
    -- configuration, selecting architectures of nodes
    for node0: router_node use entity work.router_node(type_a);
    for node1: router_node use entity work.router_node(type_a);
    for node2: router_node use entity work.router_node(type_a);
    for node3: router_node use entity work.router_node(type_b); -- Edge Node
    
    for node4: router_node use entity work.router_node(type_a);
    for node5: router_node use entity work.router_node(type_a);
    for node6: router_node use entity work.router_node(type_a);
    for node7: router_node use entity work.router_node(type_b); -- Edge Node
    
    for node8: router_node use entity work.router_node(type_a);
    for node9: router_node use entity work.router_node(type_a);
    for node10:router_node use entity work.router_node(type_a);
    for node11:router_node use entity work.router_node(type_b); -- Edge Node
    
    for node12:router_node use entity work.router_node(type_a);
    for node13:router_node use entity work.router_node(type_a);
    for node14:router_node use entity work.router_node(type_a);
    for node15:router_node use entity work.router_node(type_b); -- Edge Node
    
    -- interconnect signals (from left to right)
    signal lr_buses, -- interconnects routers from left to right
           rl_buses, -- interconnects routers from right to left
           tb_buses, -- interconnects routers from top to bottom
           bt_buses  -- interconnects routers from bottom to top
           : data_bus_array; -- 16 x 8 array type

begin
            
    node0: router_node port map(
        n_in => tb_buses(12), -- node12 -> node 0
        e_in => rl_buses(1), -- node1 -> node0
        s_in => bt_buses(4), -- node4 -> node0
        w_in => lr_buses(3), -- node3 -> node0
        d_in => din0, -- NOC input
        
        n_out => bt_buses(0), -- node0 -> node12
        e_out => lr_buses(0), -- node0 -> node1
        s_out => tb_buses(0), -- node0 -> node4
        w_out => rl_buses(0), -- node0 -> node3
        d_out => dout0, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset,
        clock => clock
    );
    
    node1: router_node port map(
        n_in => tb_buses(13), -- node13 -> node1
        e_in => rl_buses(2), -- node2 -> node1
        s_in => bt_buses(5), -- node5 -> node1
        w_in => lr_buses(0), -- node0 -> node1
        d_in => din1, -- NOC input
        
        n_out => bt_buses(1), -- node1 -> node13
        e_out => lr_buses(1), -- node1 -> node2
        s_out => tb_buses(1), -- node1 -> node5
        w_out => rl_buses(1), -- node1 -> node0
        d_out => dout1, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset,
        clock => clock
    );
    
    node2: router_node port map(
        n_in => tb_buses(14), -- node14 -> node2
        e_in => rl_buses(3), -- node3 -> node2
        s_in => bt_buses(6), -- node6 -> node2
        w_in => lr_buses(1), -- node1 -> node2
        d_in => din2, -- NOC input
        
        n_out => bt_buses(2), -- node2 -> node14
        e_out => lr_buses(2), -- node2 -> node3
        s_out => tb_buses(2), -- node2 -> node6
        w_out => rl_buses(2), -- node2 -> node1
        d_out => dout2, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset,
        clock => clock
    );
    
    node3: router_node port map(
        n_in => tb_buses(15), -- node15 -> node3
        e_in => rl_buses(0), -- node0 -> node3
        s_in => bt_buses(7), -- node7 -> node3
        w_in => lr_buses(2), -- node2 -> node3
        d_in => din3, -- NOC input
        
        n_out => bt_buses(3), -- node3 -> node15
        e_out => lr_buses(3), -- node3 -> node0
        s_out => tb_buses(3), -- node3 -> node7
        w_out => rl_buses(3), -- node3 -> node2
        d_out => dout3, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node4: router_node port map(
        n_in => tb_buses(0), -- node0 -> node4
        e_in => rl_buses(5), -- node5 -> node4
        s_in => bt_buses(8), -- node8 -> node4
        w_in => lr_buses(7), -- node7 -> node4
        d_in => din4, -- NOC input
        
        n_out => bt_buses(4), -- node4 -> node0
        e_out => lr_buses(4), -- node4 -> node5
        s_out => tb_buses(4), -- node4 -> node8
        w_out => rl_buses(4), -- node4 -> node7
        d_out => dout4, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node5: router_node port map(
        n_in => tb_buses(1), -- node1 -> node5
        e_in => rl_buses(6), -- node6 -> node5
        s_in => bt_buses(9), -- node9 -> node5
        w_in => lr_buses(4), -- node4 -> node5
        d_in => din5, -- NOC input
        
        n_out => bt_buses(5), -- node5 -> node1
        e_out => lr_buses(5), -- node5 -> node6
        s_out => tb_buses(5), -- node5 -> node9
        w_out => rl_buses(5), -- node5 -> node4
        d_out => dout5, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node6: router_node port map(
        n_in => tb_buses(2), -- node2 -> node6
        e_in => rl_buses(7), -- node7 -> node6
        s_in => bt_buses(10), -- node10 -> node6
        w_in => lr_buses(5), -- node5 -> node6
        d_in => din6, -- NOC input
        
        n_out => bt_buses(6), -- node6 -> node2
        e_out => lr_buses(6), -- node6 -> node7
        s_out => tb_buses(6), -- node6 -> node10
        w_out => rl_buses(6), -- node6 -> node5
        d_out => dout6, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node7: router_node port map(
        n_in => tb_buses(3), -- node3 -> node7
        e_in => rl_buses(4), -- node4 -> node7
        s_in => bt_buses(11), -- node11 -> node7
        w_in => lr_buses(6), -- node6 -> node7
        d_in => din7, -- NOC input
        
        n_out => bt_buses(7), -- node7 -> node3
        e_out => lr_buses(7), -- node7 -> node4
        s_out => tb_buses(7), -- node7 -> node11
        w_out => rl_buses(7), -- node7 -> node6
        d_out => dout7, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node8: router_node port map(
        n_in => tb_buses(4), -- node4 -> node8
        e_in => rl_buses(9), -- node9 -> node8
        s_in => bt_buses(12), -- node12 -> node8
        w_in => lr_buses(11), -- node11 -> node8
        d_in => din8, -- NOC input
        
        n_out => bt_buses(8), -- node8 -> node4
        e_out => lr_buses(8), -- node8 -> node9
        s_out => tb_buses(8), -- node8 -> node12
        w_out => rl_buses(8), -- node8 -> node11
        d_out => dout8, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node9: router_node port map(
        n_in => tb_buses(5), -- node5 -> node9
        e_in => rl_buses(10), -- node10 -> node9
        s_in => bt_buses(13), -- node13 -> node9
        w_in => lr_buses(8), -- node8 -> node9
        d_in => din9, -- NOC input
        
        n_out => bt_buses(9), -- node9 -> node5
        e_out => lr_buses(9), -- node9 -> node10
        s_out => tb_buses(9), -- node9 -> node13
        w_out => rl_buses(9), -- node9 -> node8
        d_out => dout9, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node10: router_node port map(
        n_in => tb_buses(6), -- node6 -> node10
        e_in => rl_buses(11), -- node11 -> node10
        s_in => bt_buses(14), -- node14 -> node10
        w_in => lr_buses(9), -- node9 -> node10
        d_in => din10, -- NOC input
        
        n_out => bt_buses(10), -- node10 -> node6
        e_out => lr_buses(10), -- node10 -> node11
        s_out => tb_buses(10), -- node10 -> node14
        w_out => rl_buses(10), -- node10 -> node9
        d_out => dout10, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node11: router_node port map(
        n_in => tb_buses(7), -- node7 -> node11
        e_in => rl_buses(8), -- node8 -> node11
        s_in => bt_buses(15), -- node15 -> node11
        w_in => lr_buses(10), -- node10 -> node11
        d_in => din11, -- NOC input
        
        n_out => bt_buses(11), -- node11 -> node7
        e_out => lr_buses(11), -- node11 -> node8
        s_out => tb_buses(11), -- node11 -> node15
        w_out => rl_buses(11), -- node11 -> node10
        d_out => dout11, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node12: router_node port map(
        n_in => tb_buses(8), -- node8 -> node12
        e_in => rl_buses(13), -- node13 -> node12
        s_in => bt_buses(0), -- node0 -> node12
        w_in => lr_buses(15), -- node15 -> node12
        d_in => din12, -- NOC input
        
        n_out => bt_buses(12), -- node12 -> node8
        e_out => lr_buses(12), -- node12 -> node13
        s_out => tb_buses(12), -- node12 -> node0
        w_out => rl_buses(12), -- node12 -> node15
        d_out => dout12, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );
    
    node13: router_node port map(
        n_in => tb_buses(9), -- node9 -> node13
        e_in => rl_buses(14), -- node14 -> node13
        s_in => bt_buses(1), -- node1 -> node13
        w_in => lr_buses(12), -- node12 -> node13
        d_in => din13, -- NOC input
        
        n_out => bt_buses(13), -- node13 -> node9
        e_out => lr_buses(13), -- node13 -> node14
        s_out => tb_buses(13), -- node13 -> node1
        w_out => rl_buses(13), -- node13 -> node12
        d_out => dout13, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );

    node14: router_node port map(
        n_in => tb_buses(10), -- node10 -> node14
        e_in => rl_buses(15), -- node15 -> node14
        s_in => bt_buses(2), -- node2 -> node14
        w_in => lr_buses(13), -- node13 -> node14
        d_in => din14, -- NOC input
        
        n_out => bt_buses(14), -- node14 -> node10
        e_out => lr_buses(14), -- node14 -> node15
        s_out => tb_buses(14), -- node14 -> node2
        w_out => rl_buses(14), -- node14 -> node13
        d_out => dout14, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );

    node15: router_node port map(
        n_in => tb_buses(11), -- node11 -> node15
        e_in => rl_buses(12), -- node12 -> node15
        s_in => bt_buses(3), -- node3 -> node15
        w_in => lr_buses(14), -- node14 -> node15
        d_in => din15, -- NOC input
        
        n_out => bt_buses(15), -- node15 -> node11
        e_out => lr_buses(15), -- node15 -> node12
        s_out => tb_buses(15), -- node15 -> node3
        w_out => rl_buses(15), -- node15 -> node14
        d_out => dout15, -- NOC output
        
        rt_inst_addr => address, -- routing instruction address
        reset => reset, 
        clock => clock
    );     
    
end architecture cyclic_network;

