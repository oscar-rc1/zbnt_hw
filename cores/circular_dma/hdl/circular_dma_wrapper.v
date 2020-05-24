/*
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

module circular_dma_w
#(
	parameter C_AXI_WIDTH = 32,
	parameter C_ADDR_WIDTH = 32,
	parameter C_AXIS_WIDTH = 64,
	parameter C_MAX_BURST = 16,
	parameter C_AXIS_OCCUP_WIDTH = 16,
	parameter C_VALUE_AWPROT = 3'd0,
	parameter C_VALUE_AWCACHE = 4'b1111,
	parameter C_VALUE_AWUSER = 4'b1111,
	parameter C_IRQ_TYPE = 0
)
(
	input wire clk,
	input wire rst_n,

	output wire irq,
	input wire irq_ack,

	output wire fifo_flush_req,
	input wire fifo_flush_ack,
	input wire [C_AXIS_OCCUP_WIDTH-1:0] fifo_occupancy,

	// S_AXI

	input wire [11:0] s_axi_awaddr,
	input wire [2:0] s_axi_awprot,
	input wire s_axi_awvalid,
	output wire s_axi_awready,

	input wire [C_AXI_WIDTH-1:0] s_axi_wdata,
	input wire [(C_AXI_WIDTH/8)-1:0] s_axi_wstrb,
	input wire s_axi_wvalid,
	output wire s_axi_wready,

	output wire [1:0] s_axi_bresp,
	output wire s_axi_bvalid,
	input wire s_axi_bready,

	input wire [11:0] s_axi_araddr,
	input wire [2:0] s_axi_arprot,
	input wire s_axi_arvalid,
	output wire s_axi_arready,

	output wire [C_AXI_WIDTH-1:0] s_axi_rdata,
	output wire [1:0] s_axi_rresp,
	output wire s_axi_rvalid,
	input wire s_axi_rready,

	// M_AXI

	output wire [C_ADDR_WIDTH-1:0] m_axi_awaddr,
	output wire [2:0] m_axi_awprot,
	output wire [7:0] m_axi_awlen,
	output wire [1:0] m_axi_awburst,
	output wire [2:0] m_axi_awsize,
	output wire [3:0] m_axi_awuser,
	output wire [3:0] m_axi_awcache,
	output wire m_axi_awvalid,
	input wire m_axi_awready,

	output wire [C_AXIS_WIDTH-1:0] m_axi_wdata,
	output wire [(C_AXIS_WIDTH/8)-1:0] m_axi_wstrb,
	output wire m_axi_wlast,
	output wire m_axi_wvalid,
	input wire m_axi_wready,

	input wire [1:0] m_axi_bresp,
	input wire m_axi_bvalid,
	output wire m_axi_bready,

	// S_AXIS_S2MM

	input wire [C_AXIS_WIDTH-1:0] s_axis_s2mm_tdata,
	input wire s_axis_s2mm_tlast,
	input wire s_axis_s2mm_tvalid,
	output wire s_axis_s2mm_tready
);
	assign m_axi_awsize = $clog2(C_AXIS_WIDTH/8);
	assign m_axi_wstrb = {(C_AXIS_WIDTH/8){1'b1}};
	assign m_axi_awprot = C_VALUE_AWPROT;
	assign m_axi_awuser = C_VALUE_AWUSER;
	assign m_axi_awcache = C_VALUE_AWCACHE;
	assign m_axi_awburst = 2'd1;

	circular_dma
	#(
		C_AXI_WIDTH,
		C_ADDR_WIDTH,
		C_AXIS_WIDTH,
		C_MAX_BURST,
		C_AXIS_OCCUP_WIDTH,
		C_IRQ_TYPE
	)
	U0
	(
		.clk(clk),
		.rst_n(rst_n),

		.irq(irq),
		.irq_ack(irq_ack),

		.fifo_flush_req(fifo_flush_req),
		.fifo_flush_ack(fifo_flush_ack),
		.fifo_occupancy(fifo_occupancy),

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

		// M_AXI

		.m_axi_awaddr(m_axi_awaddr),
		.m_axi_awlen(m_axi_awlen),
		.m_axi_awvalid(m_axi_awvalid),
		.m_axi_awready(m_axi_awready),

		.m_axi_wdata(m_axi_wdata),
		.m_axi_wlast(m_axi_wlast),
		.m_axi_wvalid(m_axi_wvalid),
		.m_axi_wready(m_axi_wready),

		.m_axi_bresp(m_axi_bresp),
		.m_axi_bvalid(m_axi_bvalid),
		.m_axi_bready(m_axi_bready),

		// S_AXIS_S2MM

		.s_axis_s2mm_tdata(s_axis_s2mm_tdata),
		.s_axis_s2mm_tlast(s_axis_s2mm_tlast),
		.s_axis_s2mm_tvalid(s_axis_s2mm_tvalid),
		.s_axis_s2mm_tready(s_axis_s2mm_tready)
	);
endmodule
