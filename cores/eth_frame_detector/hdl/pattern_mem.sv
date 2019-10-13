/*
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

module pattern_mem #(parameter C_AXI_WIDTH = 32)
(
	input logic clk,

	input logic [10:0] a,
	input logic [C_AXI_WIDTH-1:0] d,
	output logic [C_AXI_WIDTH-1:0] qspo,
	input logic we,

	input logic [10:0] dpra,
	output logic [31:0] qdpo
);
	logic [C_AXI_WIDTH-1:0] qdpo_full;
	logic [31:0] qdpo_bytes[0:(C_AXI_WIDTH/32)-1];

	xpm_memory_tdpram
	#(
		.ADDR_WIDTH_A(11),
		.ADDR_WIDTH_B(11),
		.BYTE_WRITE_WIDTH_A(C_AXI_WIDTH),
		.CLOCKING_MODE("common_clock"),
		.MEMORY_INIT_FILE("none"),
		.MEMORY_INIT_PARAM("0"),
		.MEMORY_OPTIMIZATION("true"),
		.MEMORY_SIZE(65536),
		.MESSAGE_CONTROL(0),
		.READ_DATA_WIDTH_A(C_AXI_WIDTH),
		.READ_DATA_WIDTH_B(C_AXI_WIDTH),
		.READ_LATENCY_A(1),
		.READ_LATENCY_B(1),
		.READ_RESET_VALUE_A("0"),
		.READ_RESET_VALUE_B("0"),
		.RST_MODE_A("SYNC"),
		.RST_MODE_B("SYNC"),
		.USE_EMBEDDED_CONSTRAINT(0),
		.USE_MEM_INIT(0),
		.WRITE_DATA_WIDTH_A(C_AXI_WIDTH)
	)
	U0
	(
		.clka(clk),
		.clkb(clk),

		.rsta(1'b0),
		.rstb(1'b0),
		.sleep(1'b0),

		.addra(a[10:$clog2(C_AXI_WIDTH/32)]),
		.dina(d),
		.douta(qspo),
		.wea(we),

		.addrb(dpra[10:$clog2(C_AXI_WIDTH/32)]),
		.doutb(qdpo_full),

		.ena(1'b1),
		.enb(1'b1),

		.regcea(1'b1),
		.regceb(1'b1),

		.injectdbiterra(1'b0),
		.injectdbiterrb(1'b0),

		.injectsbiterra(1'b0),
		.injectsbiterrb(1'b0)
	);

	for(genvar i = 0; i < C_AXI_WIDTH/32; ++i) begin
		always_comb begin
			qdpo_bytes[i] = qdpo_full[i*32+31:i*32];
		end
	end

	always_comb begin
		if(C_AXI_WIDTH == 32) begin
			qdpo = qdpo_full;
		end else begin
			qdpo = qdpo_bytes[dpra[$clog2(C_AXI_WIDTH/32)-1:0]];
		end
	end
endmodule
