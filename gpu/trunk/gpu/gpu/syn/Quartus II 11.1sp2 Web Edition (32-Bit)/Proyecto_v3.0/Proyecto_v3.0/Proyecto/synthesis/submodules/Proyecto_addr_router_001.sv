// (C) 2001-2012 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/11.1sp2/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2011/11/10 $
// $Author: max $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module Proyecto_addr_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 9,
               DEFAULT_DESTID = 9 
   )
  (output [87 - 84 : 0] default_destination_id,
   output [13-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[87 - 84 : 0];
  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1)
      assign default_src_channel = '0;
    else
      assign default_src_channel = 13'b1 << DEFAULT_CHANNEL;
  end endgenerate

endmodule


module Proyecto_addr_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [89-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [89-1    : 0] src_data,
    output reg [13-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 87;
    localparam PKT_DEST_ID_L = 84;
    localparam ST_DATA_W = 89;
    localparam ST_CHANNEL_W = 13;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;




    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(32'h4000000 - 32'h2000000);
    localparam PAD1 = log2ceil(32'h6000000 - 32'h4000000);
    localparam PAD2 = log2ceil(32'h6004000 - 32'h6000000);
    localparam PAD3 = log2ceil(32'h6005000 - 32'h6004000);
    localparam PAD4 = log2ceil(32'h6006000 - 32'h6005800);
    localparam PAD5 = log2ceil(32'h6006400 - 32'h6006000);
    localparam PAD6 = log2ceil(32'h6006440 - 32'h6006400);
    localparam PAD7 = log2ceil(32'h6006460 - 32'h6006440);
    localparam PAD8 = log2ceil(32'h6006470 - 32'h6006460);
    localparam PAD9 = log2ceil(32'h6006478 - 32'h6006470);
    localparam PAD10 = log2ceil(32'h600647c - 32'h6006478);
    localparam PAD11 = log2ceil(32'h6006480 - 32'h600647c);
    localparam PAD12 = log2ceil(32'h6006481 - 32'h6006480);

    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 32'h6006481;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;
    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [13-1 : 0] default_src_channel;




    Proyecto_addr_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_src_channel (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;

        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;
        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

        // ( 0x2000000 .. 0x4000000 )
        if ( {address[RG:PAD0],{PAD0{1'b0}}} == 'h2000000 ) begin
            src_channel = 13'b0001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
        end

        // ( 0x4000000 .. 0x6000000 )
        if ( {address[RG:PAD1],{PAD1{1'b0}}} == 'h4000000 ) begin
            src_channel = 13'b0000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
        end

        // ( 0x6000000 .. 0x6004000 )
        if ( {address[RG:PAD2],{PAD2{1'b0}}} == 'h6000000 ) begin
            src_channel = 13'b0010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
        end

        // ( 0x6004000 .. 0x6005000 )
        if ( {address[RG:PAD3],{PAD3{1'b0}}} == 'h6004000 ) begin
            src_channel = 13'b0000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
        end

        // ( 0x6005800 .. 0x6006000 )
        if ( {address[RG:PAD4],{PAD4{1'b0}}} == 'h6005800 ) begin
            src_channel = 13'b0000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
        end

        // ( 0x6006000 .. 0x6006400 )
        if ( {address[RG:PAD5],{PAD5{1'b0}}} == 'h6006000 ) begin
            src_channel = 13'b0100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
        end

        // ( 0x6006400 .. 0x6006440 )
        if ( {address[RG:PAD6],{PAD6{1'b0}}} == 'h6006400 ) begin
            src_channel = 13'b0000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
        end

        // ( 0x6006440 .. 0x6006460 )
        if ( {address[RG:PAD7],{PAD7{1'b0}}} == 'h6006440 ) begin
            src_channel = 13'b0000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
        end

        // ( 0x6006460 .. 0x6006470 )
        if ( {address[RG:PAD8],{PAD8{1'b0}}} == 'h6006460 ) begin
            src_channel = 13'b0000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
        end

        // ( 0x6006470 .. 0x6006478 )
        if ( {address[RG:PAD9],{PAD9{1'b0}}} == 'h6006470 ) begin
            src_channel = 13'b0000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
        end

        // ( 0x6006478 .. 0x600647c )
        if ( {address[RG:PAD10],{PAD10{1'b0}}} == 'h6006478 ) begin
            src_channel = 13'b0000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
        end

        // ( 0x600647c .. 0x6006480 )
        if ( {address[RG:PAD11],{PAD11{1'b0}}} == 'h600647c ) begin
            src_channel = 13'b0000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
        end

        // ( 0x6006480 .. 0x6006481 )
        if ( {address[RG:PAD12],{PAD12{1'b0}}} == 'h6006480 ) begin
            src_channel = 13'b1000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
        end
    end

    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[63:0] val;
        reg [63:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


