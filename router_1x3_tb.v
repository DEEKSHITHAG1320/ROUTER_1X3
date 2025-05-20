`timescale 1ps/1fs

module router_1x3_tb();

reg clk,rstn;
reg read_en0,read_en1,read_en2;
reg [7:0] data_in;
reg pkt_valid;
wire [7:0]data_out0,data_out1,data_out2;
wire valid_out0,valid_out1,valid_out2;
wire error,busy;
integer k;

router_1x3 DUT (.clk(clk), .rstn(rstn), .read_en0(read_en0), .read_en1(read_en1), .read_en2(read_en2), .data_in(data_in), .pkt_valid(pkt_valid), 
					.data_out0(data_out0), .data_out1(data_out1), .data_out2(data_out2), .valid_out0(valid_out0), .valid_out1(valid_out1), 
					.valid_out2(valid_out2), .error(error), .busy(busy));


initial 
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

task resetn;
	begin
		@(negedge clk)
		rstn = 1'b0;
		@(negedge clk)
		rstn = 1'b1;
	end
endtask

task initialise;
{rstn,read_en0,read_en1,read_en2,pkt_valid} = 0;
endtask

task packet_14;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		@(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = 6'd14;
		addr = 2'b00;
		header = {payload_len,addr};
		parity = 1'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(k=0; k<payload_len; k=k+1)
		begin
			@(negedge clk);
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity ^payload_data;
		end
		@(negedge clk);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;	
	end
endtask

task packet_8;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		@(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = 6'd8;
		addr = 2'b01;
		header = {payload_len,addr};
		parity = 1'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(k=0; k<payload_len; k=k+1)
		begin
			@(negedge clk);
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity ^payload_data;
		end
		@(negedge clk);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;	
	end
endtask

task packet_16;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		@(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = 6'd16;
		addr = 2'b10;
		header = {payload_len,addr};
		parity = 1'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(k=0; k<payload_len; k=k+1)
		begin
			@(negedge clk);
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity ^payload_data;
		end
		@(negedge clk);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;	
	end
endtask

event e1,e2;

task packet_random;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		->e1;
		@(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = {$random} % 64;
		addr = 2'b00;
		header = {payload_len,addr};
		parity = 1'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(k=0; k<payload_len; k=k+1)
		begin
			@(negedge clk);
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity ^payload_data;
		end
		@(negedge clk);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;	
	end
endtask

task packet_21;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		->e2;
		@(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = 6'd21;
		addr = 2'b01;
		header = {payload_len,addr};
		parity = 1'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(k=0; k<payload_len; k=k+1)
		begin
			@(negedge clk);
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity ^payload_data;
		end
		@(negedge clk);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;	
	end
endtask

initial 
begin
	initialise;
	
	resetn;
	packet_14;
	repeat(3) @(negedge clk);
	@(negedge clk)
	read_en0 = 1'b1;
	wait(~valid_out0)
	@(negedge clk)
	read_en0 = 1'b0;
	
	resetn;
	packet_8;
	@(negedge clk)
	read_en1 = 1'b1;
	wait(~valid_out1)
	@(negedge clk)
	read_en1 = 1'b0;
	
	resetn;
	packet_16;
	repeat(1) @(negedge clk);
	@(negedge clk)
	read_en2 = 1'b1;
	wait(~valid_out2)
	@(negedge clk)
	read_en2 = 1'b0;
	
	resetn;
	packet_21;
	packet_random;
	
	#200 $finish;
	
end

initial 
begin
	@(e1)
	@(negedge clk)
	read_en0 = 1'b1;
	wait(~valid_out0)
	@(negedge clk);
	//read_en1 = 1'b0;
end

initial 
begin
	@(e2)
	@(negedge clk)
	read_en1 = 1'b1;
	wait(~valid_out1)
	@(negedge clk);
	//read_en2 = 1'b0;
end


endmodule
