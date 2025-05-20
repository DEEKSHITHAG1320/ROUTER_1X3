`timescale 1ns / 1ps
module router_1x3(clk,rstn,read_en0,read_en1,read_en2,data_in,pkt_valid,data_out0,data_out1,data_out2,valid_out0,valid_out1,valid_out2,error,busy);
input clk,rstn;
input read_en0,read_en1,read_en2;
input [7:0] data_in;
input pkt_valid;
output [7:0]data_out0,data_out1,data_out2;
output valid_out0,valid_out1,valid_out2;
output error,busy;

//FIFO
wire [2:0]write_enb;
wire [7:0] data_out;

//INSTANTIATION OF FIFO 
router_fifo FIFO_0 (.clock(clk), .reset_n(rstn), .write_en(write_enb[0]), .soft_reset(sft_rst_0), .read_en(read_en0), .data_in(data_out), .lfd_state(lfd), .empty(empty_0), .data_out(data_out0), .full(full_0));
router_fifo FIFO_1 (.clock(clk), .reset_n(rstn), .write_en(write_enb[1]), .soft_reset(sft_rst_1), .read_en(read_en1), .data_in(data_out), .lfd_state(lfd), .empty(empty_1), .data_out(data_out1), .full(full_1));
router_fifo FIFO_2 (.clock(clk), .reset_n(rstn), .write_en(write_enb[2]), .soft_reset(sft_rst_2), .read_en(read_en2), .data_in(data_out), .lfd_state(lfd), .empty(empty_2), .data_out(data_out2), .full(full_2));



//INSTANTIATION OF SYNCHRONISER 
router_synchronizer SYNCHRONISER (.clk(clk), .rstn(rstn), .write_en_reg(write_enb_reg), .data_in(data_in[1:0]), .detect_addr(detect_add), 
				 .vld0(valid_out0), .vld1(valid_out1), .vld2(valid_out2), .re0(read_en0), .re1(read_en1), .re2(read_en2), 
				 .write_en(write_enb), .fifo_full(fifo_full), .empty0(empty_0), .empty1(empty_1), .empty2(empty_2),
				 .sft_rst0(sft_rst_0), .sft_rst1(sft_rst_1), .sft_rst2(sft_rst_2), .full0(full_0), .full1(full_1), .full2(full_2));
   


//INSTANTIATION OF FSM
router_fsm FSM (.clk(clk), .rstn(rstn), .pkt_valid(pkt_valid), .busy(busy), .parity_done(parity_done), .data_in(data_in[1:0]), .sft_rst0(sft_rst_0), .sft_rst1(sft_rst_1), .sft_rst2(sft_rst_2), .fifo_full(fifo_full),
	       .low_pkt_valid(low_pkt_valid), .fifo_empty0(empty_0), .fifo_empty1(empty_1), .fifo_empty2(empty_2), .detect_add(detect_add), .ld_state(ld_state), .laf_state(laf_state), .full_state(full_state), 
	       .write_enb_reg(write_enb_reg), .rst_int_reg(rst_int_reg), .lfd_state(lfd));



//INSTANTIATION OF REGISTER
router_register REGISTER (.clk(clk), .rstn(rstn), .pkt_valid(pkt_valid), .data_in(data_in), .fifo_full(fifo_full), .rst_int_reg(rst_int_reg), .detect_addr(detect_add), .ld_state(ld_state), .laf_state(laf_state),
                	.full_state(full_state), .lfd_state(lfd), .parity_done(parity_done), .low_pkt_valid(low_pkt_valid), .error(error), .data_out(data_out));

endmodule

