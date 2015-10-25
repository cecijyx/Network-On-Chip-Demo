------------------------------
-- CoE 4DM4 Lab 2           --
-- Author: Jin Kuan Zhou    --
-- Student Number: 1144351  --
-- Date: October 21th, 2015 --
------------------------------

---------------------------------------------------------------------------
-- This is an implementation of a 8-bit 5x5 crossbar switch              --
---------------------------------------------------------------------------

-- declare a W-bit D Flip-Flop
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;
entity d_flipflop is
    port(
        d      : in std_logic_vector(W-1 downto 0);
        r, clk : in std_logic;
        q      : out std_logic_vector(W-1 downto 0)
    );
end entity d_flipflop;

architecture behavior of d_flipflop is
begin
    process(clk, r)
    begin
        -- Asynchronous reset
        if (r = '1') then
            q <= (W-1 downto 0 => '0');
        elsif (rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end architecture behavior;

-- declare a pipelined 5x5 cross-bar switch
library ieee;
use ieee.std_logic_1164.all;
use work.constants_pkg.all;

entity switch5x5 is
    port(
        in0, in1, in2, in3, in4      : in std_logic_vector(W-1 downto 0);
        sel0, sel1, sel2, sel3, sel4 : in std_logic_vector(M-1 downto 0);  
        reset, clock                 : in std_logic;
        out0, out1, out2, out3, out4 : out std_logic_vector(W-1 downto 0)
    );
end entity switch5x5;

architecture switch5x5_arc1 of switch5x5 is
    signal mux_in0, 
           mux_in1, 
           mux_in2, 
           mux_in3,
           mux_in4,  
           mux_out0, 
           mux_out1,
           mux_out2,
           mux_out3,
           mux_out4 : std_logic_vector(W-1 downto 0) := (others => '0');
    
    component d_flipflop
        port(
            d      : in std_logic_vector(W-1 downto 0);
            r, clk : in std_logic;
            q      : out std_logic_vector(W-1 downto 0)
        );
    end component;
begin
    
    -- instantiates 5 D Flip-Flops for inputs
    dff0 : d_flipflop port map(d=>in0, r=>reset, clk=>clock, q=>mux_in0);
    dff1 : d_flipflop port map(d=>in1, r=>reset, clk=>clock, q=>mux_in1);
    dff2 : d_flipflop port map(d=>in2, r=>reset, clk=>clock, q=>mux_in2);
    dff3 : d_flipflop port map(d=>in3, r=>reset, clk=>clock, q=>mux_in3);
    dff4 : d_flipflop port map(d=>in4, r=>reset, clk=>clock, q=>mux_in4);
    
    -- instantiates 5 D Flip-Flops for outputs
    dff5 : d_flipflop port map(d=>mux_out0, r=>reset, clk=>clock, q=>out0);
    dff6 : d_flipflop port map(d=>mux_out1, r=>reset, clk=>clock, q=>out1);
    dff7 : d_flipflop port map(d=>mux_out2, r=>reset, clk=>clock, q=>out2);
    dff8 : d_flipflop port map(d=>mux_out3, r=>reset, clk=>clock, q=>out3);
    dff9 : d_flipflop port map(d=>mux_out4, r=>reset, clk=>clock, q=>out4);
    
    mux0:process(sel0, mux_in0, mux_in1, mux_in2, mux_in3, mux_in4) is
    begin
        case sel0 is
            when "000" => mux_out0 <= mux_in0;
            when "001" => mux_out0 <= mux_in1;
            when "010" => mux_out0 <= mux_in2;
            when "011" => mux_out0 <= mux_in3;
            when "100" => mux_out0 <= mux_in4;
            when others => mux_out0 <= (W-1 downto 0 => 'X'); 
        end case;
    end process mux0;

    mux1:process(sel1, mux_in0, mux_in1, mux_in2, mux_in3, mux_in4) is
    begin
        case sel1 is
            when "000" => mux_out1 <= mux_in0;
            when "001" => mux_out1 <= mux_in1;
            when "010" => mux_out1 <= mux_in2;
            when "011" => mux_out1 <= mux_in3;
            when "100" => mux_out1 <= mux_in4;
            when others => mux_out1 <= (W-1 downto 0 => 'X'); 
        end case;
    end process mux1;
    
    mux2:process(sel2, mux_in0, mux_in1, mux_in2, mux_in3, mux_in4) is
    begin
        case sel2 is
            when "000" => mux_out2 <= mux_in0;
            when "001" => mux_out2 <= mux_in1;
            when "010" => mux_out2 <= mux_in2;
            when "011" => mux_out2 <= mux_in3;
            when "100" => mux_out2 <= mux_in4;
            when others => mux_out2 <= (W-1 downto 0 => 'X');  
        end case;
    end process mux2;
    
    mux3:process(sel3, mux_in0, mux_in1, mux_in2, mux_in3, mux_in4) is
    begin
        case sel3 is
            when "000" => mux_out3 <= mux_in0;
            when "001" => mux_out3 <= mux_in1;
            when "010" => mux_out3 <= mux_in2;
            when "011" => mux_out3 <= mux_in3;
            when "100" => mux_out3 <= mux_in4;
            when others => mux_out3 <= (W-1 downto 0 => 'X');  
        end case;
    end process mux3;
    
    mux4:process(sel4, mux_in0, mux_in1, mux_in2, mux_in3, mux_in4) is
    begin
        case sel4 is
            when "000" => mux_out4 <= mux_in0;
            when "001" => mux_out4 <= mux_in1;
            when "010" => mux_out4 <= mux_in2;
            when "011" => mux_out4 <= mux_in3;
            when "100" => mux_out4 <= mux_in4;
            when others => mux_out4 <= (W-1 downto 0 => 'X');  
        end case;
    end process mux4;
    
end architecture switch5x5_arc1;

