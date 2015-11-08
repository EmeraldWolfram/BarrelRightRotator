`timescale 1ns/1ns
`define PERIOD 1

module barrel_tb();
	reg clk, reset, Load;
	reg [2:0] sel;
	reg [7:0] data_in;
	wire [7:0] data_out;
	integer errors;
	integer i, j;
	
	//*****************GLOBAL CLOCK & RESET********************
	initial begin
	clk <= 0;
	forever #(`PERIOD) clk = ~clk;
	end

	initial begin
	reset <= 1;
	@(posedge clk)
	@(negedge clk) reset = 0;
	end
	//***********************MAIN BLOCK************************
	initial begin
	errors 	= 0;
	Load	= 0;
	check_OUTPUT_NO_LOAD();
	Load	= 1;
	check_OUTPUT_LOAD();
	if(errors != 0)	$display("Error: %d", errors);
	else		$display("Successfully tested with zero error!");
#20	$finish;
	end
	//*********************INSTANTIATION*******************************************************************
	//barrel	#(.data_size(8))	test(.clk(clk),.reset(reset),.Load(Load), .sel(sel),
	//							.data_in(data_in),.data_out(data_out));

	barrel_wrong	#(.data_size(8))	test(.clk(clk),.reset(reset),.Load(Load), .sel(sel),
							.data_in(data_in),.data_out(data_out));
	//**********************ALL TASK***********************************************************************
	task verify_OUTPUT;
	input [7:0] expected_value;
	begin
		if(data_out[7:0] != expected_value[7:0])
			begin
			errors = errors + 1;
			$display("Input Data = %b\tsel = %d\tSimulated Output = %b\tExpected Output = %b\t at time %dns", 
			data_in, sel, data_out, expected_value, $time);
			end
	end
	endtask
	//*******************************************************
	task check_OUTPUT_LOAD;
	reg [7:0] expectedOut;
	reg [7:0] temp_store;
	begin
	while(reset == 1)
		begin	
		verify_OUTPUT(8'd0);	
		end

	for(i = 0; i < 4;i = i+1)
		begin
	  	data_in = {$random};
		for(j = 0; j < 8; j = j + 1)
			begin
			sel = j;
			temp_store[7:0] = data_in << (8-sel);
			expectedOut = (data_in >> sel) | temp_store;
		#2	verify_OUTPUT(expectedOut);
			end
		end
	end
	endtask

	task check_OUTPUT_NO_LOAD;
	reg [7:0] expectedOut;
	reg [7:0] temp_store;
	begin
	while(reset == 1)
		begin	
		verify_OUTPUT(8'd0);	
		end

	for(i = 0; i < 4;i = i+1)
		data_in = {$random};
		for(j = 0; j < 8; j = j + 1)
			begin
			sel = j;
			temp_store[7:0] = data_out << (8-sel);
			expectedOut = (data_out >> sel) | temp_store;
		#2	verify_OUTPUT(expectedOut);
			end
	end
	endtask
endmodule



	