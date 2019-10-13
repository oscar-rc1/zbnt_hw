/*
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

/*!
	eth_frame_detector: Ethernet Frame Detector

	This module connects two network interfaces, behaving like a MitM. Received frames are stored in a FIFO
	and transmitted on the other interface. Incoming data is compared	against a set of user-configurable
	patterns and if a match is found, the current timestamp is stored in a FIFO together with information
	regarding the matched patterns.
*/

module eth_frame_detector #(parameter C_AXI_WIDTH = 32)
(
	// S_AXI : AXI4-Lite slave interface (from PS)

	input logic s_axi_clk,
	input logic s_axi_resetn,

	input logic [15:0] s_axi_awaddr,
	input logic [2:0] s_axi_awprot,
	input logic s_axi_awvalid,
	output logic s_axi_awready,

	input logic [C_AXI_WIDTH-1:0] s_axi_wdata,
	input logic [(C_AXI_WIDTH/8)-1:0] s_axi_wstrb,
	input logic s_axi_wvalid,
	output logic s_axi_wready,

	output logic [1:0] s_axi_bresp,
	output logic s_axi_bvalid,
	input logic s_axi_bready,

	input logic [15:0] s_axi_araddr,
	input logic [2:0] s_axi_arprot,
	input logic s_axi_arvalid,
	output logic s_axi_arready,

	output logic [C_AXI_WIDTH-1:0] s_axi_rdata,
	output logic [1:0] s_axi_rresp,
	output logic s_axi_rvalid,
	input logic s_axi_rready,

	// M_AXIS_A : AXI4-Stream master interface (to TEMAC of iface A)

	input logic m_axis_a_clk,

	output logic [7:0] m_axis_a_tdata,
	output logic m_axis_a_tuser,
	output logic m_axis_a_tlast,
	output logic m_axis_a_tvalid,
	input logic m_axis_a_tready,

	// S_AXIS_A : AXI4-Stream slave interface (from TEMAC of iface A)

	input logic s_axis_a_clk,

	input logic [7:0] s_axis_a_tdata,
	input logic s_axis_a_tuser,
	input logic s_axis_a_tlast,
	input logic s_axis_a_tvalid,

	// M_AXIS_B : AXI4-Stream master interface (to TEMAC of iface B)

	input logic m_axis_b_clk,

	output logic [7:0] m_axis_b_tdata,
	output logic m_axis_b_tuser,
	output logic m_axis_b_tlast,
	output logic m_axis_b_tvalid,
	input logic m_axis_b_tready,

	// S_AXIS_B : AXI4-Stream slave interface (from TEMAC of iface B)

	input logic s_axis_b_clk,

	input logic [7:0] s_axis_b_tdata,
	input logic s_axis_b_tuser,
	input logic s_axis_b_tlast,
	input logic s_axis_b_tvalid,

	// Timer

	input logic [63:0] current_time,
	input logic time_running
);
	// axi4_lite registers

	logic srst;
	logic [7:0] match_en;
	logic [3:0] match_a, match_b;
	logic [1:0] match_a_id, match_b_id;

	logic mem_a_pa_req, mem_a_pa_we, mem_a_pa_ack;
	logic mem_b_pa_req, mem_b_pa_we, mem_b_pa_ack;
	logic mem_c_pa_req, mem_c_pa_we, mem_c_pa_ack;
	logic mem_d_pa_req, mem_d_pa_we, mem_d_pa_ack;

	logic [10:0] mem_a_pa_addr;
	logic [10:0] mem_b_pa_addr;
	logic [10:0] mem_c_pa_addr;
	logic [10:0] mem_d_pa_addr;

	logic [C_AXI_WIDTH-1:0] mem_a_pa_wdata, mem_a_pa_rdata;
	logic [C_AXI_WIDTH-1:0] mem_b_pa_wdata, mem_b_pa_rdata;
	logic [C_AXI_WIDTH-1:0] mem_c_pa_wdata, mem_c_pa_rdata;
	logic [C_AXI_WIDTH-1:0] mem_d_pa_wdata, mem_d_pa_rdata;

	eth_frame_detector_axi #(C_AXI_WIDTH) U0
	(
		.clk(s_axi_clk),
		.rst_n(s_axi_resetn),

		// S_AXI

		.s_axi_awaddr(s_axi_awaddr),
		.s_axi_awprot(s_axi_awprot),
		.s_axi_awvalid(s_axi_awvalid),
		.s_axi_awready(s_axi_awready),

		.s_axi_wdata(s_axi_wdata),
		.s_axi_wstrb(s_axi_wstrb),
		.s_axi_wvalid(s_axi_wvalid),
		.s_axi_wready(s_axi_wready),

		.s_axi_bresp(s_axi_bresp),
		.s_axi_bvalid(s_axi_bvalid),
		.s_axi_bready(s_axi_bready),

		.s_axi_araddr(s_axi_araddr),
		.s_axi_arprot(s_axi_arprot),
		.s_axi_arvalid(s_axi_arvalid),
		.s_axi_arready(s_axi_arready),

		.s_axi_rdata(s_axi_rdata),
		.s_axi_rresp(s_axi_rresp),
		.s_axi_rvalid(s_axi_rvalid),
		.s_axi_rready(s_axi_rready),

		// MEM_A_PA

		.mem_a_req(mem_a_pa_req),
		.mem_a_we(mem_a_pa_we),
		.mem_a_ack(mem_a_pa_ack),

		.mem_a_addr(mem_a_pa_addr),
		.mem_a_wdata(mem_a_pa_wdata),
		.mem_a_rdata(mem_a_pa_rdata),

		// MEM_B_PA

		.mem_b_req(mem_b_pa_req),
		.mem_b_we(mem_b_pa_we),
		.mem_b_ack(mem_b_pa_ack),

		.mem_b_addr(mem_b_pa_addr),
		.mem_b_wdata(mem_b_pa_wdata),
		.mem_b_rdata(mem_b_pa_rdata),

		// MEM_C_PA

		.mem_c_req(mem_c_pa_req),
		.mem_c_we(mem_c_pa_we),
		.mem_c_ack(mem_c_pa_ack),

		.mem_c_addr(mem_c_pa_addr),
		.mem_c_wdata(mem_c_pa_wdata),
		.mem_c_rdata(mem_c_pa_rdata),

		// MEM_D_PA

		.mem_d_req(mem_d_pa_req),
		.mem_d_we(mem_d_pa_we),
		.mem_d_ack(mem_d_pa_ack),

		.mem_d_addr(mem_d_pa_addr),
		.mem_d_wdata(mem_d_pa_wdata),
		.mem_d_rdata(mem_d_pa_rdata),

		// Registers

		.srst(srst),
		.match_en(match_en),

		// Status

		.current_time(current_time),
		.time_running(time_running),

		.match_a(match_a),
		.match_a_id(match_a_id),

		.match_b(match_b),
		.match_b_id(match_b_id)
	);

	// Interface loop, transmit frames received from one interface through the other

	logic [7:0] s_axis_a_mod_tdata, s_axis_b_mod_tdata;
	logic s_axis_a_mod_tuser, s_axis_a_mod_tlast, s_axis_a_mod_tvalid;
	logic s_axis_b_mod_tuser, s_axis_b_mod_tlast, s_axis_b_mod_tvalid;

	eth_frame_loop U1
	(
		.clk(s_axi_clk),
		.rst_n(s_axi_resetn),

		// M_AXIS_A

		.m_axis_clk(m_axis_a_clk),

		.m_axis_tdata(m_axis_a_tdata),
		.m_axis_tuser(m_axis_a_tuser),
		.m_axis_tlast(m_axis_a_tlast),
		.m_axis_tvalid(m_axis_a_tvalid),
		.m_axis_tready(m_axis_a_tready),

		// S_AXIS_B

		.s_axis_clk(s_axis_b_clk),

		.s_axis_tdata(s_axis_b_mod_tdata),
		.s_axis_tuser(s_axis_b_mod_tuser),
		.s_axis_tlast(s_axis_b_mod_tlast),
		.s_axis_tvalid(s_axis_b_mod_tvalid)
	);

	eth_frame_loop U2
	(
		.clk(s_axi_clk),
		.rst_n(s_axi_resetn),

		// M_AXIS_B

		.m_axis_clk(m_axis_b_clk),

		.m_axis_tdata(m_axis_b_tdata),
		.m_axis_tuser(m_axis_b_tuser),
		.m_axis_tlast(m_axis_b_tlast),
		.m_axis_tvalid(m_axis_b_tvalid),
		.m_axis_tready(m_axis_b_tready),

		// S_AXIS_A

		.s_axis_clk(s_axis_a_clk),

		.s_axis_tdata(s_axis_a_mod_tdata),
		.s_axis_tuser(s_axis_a_mod_tuser),
		.s_axis_tlast(s_axis_a_mod_tlast),
		.s_axis_tvalid(s_axis_a_mod_tvalid)
	);

	// Match received frames against the stored patterns

	logic [10:0] pattern_a_addr, pattern_b_addr;
	logic [31:0] mem_a_pb_data, mem_b_pb_data, mem_c_pb_data, mem_d_pb_data;

	eth_frame_matcher U3
	(
		.clk(s_axi_clk),
		.rst_n(s_axi_resetn),

		.match(match_a),
		.match_id(match_a_id),
		.match_en(match_en[3:0]),

		// S_AXIS_A

		.s_axis_clk(s_axis_a_clk),

		.s_axis_tdata(s_axis_a_tdata),
		.s_axis_tuser(s_axis_a_tuser),
		.s_axis_tlast(s_axis_a_tlast),
		.s_axis_tvalid(s_axis_a_tvalid),

		// S_AXIS_A_MOD

		.m_axis_tdata(s_axis_a_mod_tdata),
		.m_axis_tuser(s_axis_a_mod_tuser),
		.m_axis_tlast(s_axis_a_mod_tlast),
		.m_axis_tvalid(s_axis_a_mod_tvalid),

		// MEM_A + MEM_B

		.pattern_addr(pattern_a_addr),
		.pattern_data(mem_a_pb_data),
		.pattern_flags(mem_b_pb_data)
	);

	eth_frame_matcher U4
	(
		.clk(s_axi_clk),
		.rst_n(s_axi_resetn),

		.match(match_b),
		.match_id(match_b_id),
		.match_en(match_en[7:4]),

		// S_AXIS_B

		.s_axis_clk(s_axis_b_clk),

		.s_axis_tdata(s_axis_b_tdata),
		.s_axis_tuser(s_axis_b_tuser),
		.s_axis_tlast(s_axis_b_tlast),
		.s_axis_tvalid(s_axis_b_tvalid),

		// S_AXIS_B_MOD

		.m_axis_tdata(s_axis_b_mod_tdata),
		.m_axis_tuser(s_axis_b_mod_tuser),
		.m_axis_tlast(s_axis_b_mod_tlast),
		.m_axis_tvalid(s_axis_b_mod_tvalid),

		// MEM_C + MEM_D

		.pattern_addr(pattern_b_addr),
		.pattern_data(mem_c_pb_data),
		.pattern_flags(mem_d_pb_data)
	);

	// Memory for storing patterns, one for each direction

	eth_frame_pattern_mem #(C_AXI_WIDTH) U5
	(
		.clk(s_axi_clk),

		// MEM_A_PA

		.mem_pa_req(mem_a_pa_req),
		.mem_pa_we(mem_a_pa_we),
		.mem_pa_ack(mem_a_pa_ack),

		.mem_pa_addr(mem_a_pa_addr),
		.mem_pa_wdata(mem_a_pa_wdata),
		.mem_pa_rdata(mem_a_pa_rdata),

		// MEM_A_PB

		.mem_pb_clk(s_axis_a_clk),
		.mem_pb_addr(pattern_a_addr),
		.mem_pb_rdata(mem_a_pb_data)
	);

	eth_frame_pattern_mem #(C_AXI_WIDTH) U6
	(
		.clk(s_axi_clk),

		// MEM_B_PA

		.mem_pa_req(mem_b_pa_req),
		.mem_pa_we(mem_b_pa_we),
		.mem_pa_ack(mem_b_pa_ack),

		.mem_pa_addr(mem_b_pa_addr),
		.mem_pa_wdata(mem_b_pa_wdata),
		.mem_pa_rdata(mem_b_pa_rdata),

		// MEM_B_PB

		.mem_pb_clk(s_axis_a_clk),
		.mem_pb_addr(pattern_a_addr),
		.mem_pb_rdata(mem_b_pb_data)
	);

	eth_frame_pattern_mem #(C_AXI_WIDTH) U7
	(
		.clk(s_axi_clk),

		// MEM_C_PA

		.mem_pa_req(mem_c_pa_req),
		.mem_pa_we(mem_c_pa_we),
		.mem_pa_ack(mem_c_pa_ack),

		.mem_pa_addr(mem_c_pa_addr),
		.mem_pa_wdata(mem_c_pa_wdata),
		.mem_pa_rdata(mem_c_pa_rdata),

		// MEM_C_PB

		.mem_pb_clk(s_axis_b_clk),
		.mem_pb_addr(pattern_b_addr),
		.mem_pb_rdata(mem_c_pb_data)
	);

	eth_frame_pattern_mem #(C_AXI_WIDTH) U8
	(
		.clk(s_axi_clk),

		// MEM_D_PA

		.mem_pa_req(mem_d_pa_req),
		.mem_pa_we(mem_d_pa_we),
		.mem_pa_ack(mem_d_pa_ack),

		.mem_pa_addr(mem_d_pa_addr),
		.mem_pa_wdata(mem_d_pa_wdata),
		.mem_pa_rdata(mem_d_pa_rdata),

		// MEM_D_PB

		.mem_pb_clk(s_axis_b_clk),
		.mem_pb_addr(pattern_b_addr),
		.mem_pb_rdata(mem_d_pb_data)
	);
endmodule
