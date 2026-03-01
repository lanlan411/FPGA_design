module light_contol_tb;

reg switch0;
reg switch1;
wire [3:0] LED_state;

light_contol u_light_contol(
    .switch0(switch0),
    .switch1(switch1),
    .LED_state(LED_state)
);

initial begin
    $fsdbDumpfile("light_control.fsdb");
    $fsdbDumpvars(0, light_contol_tb, "+all");
end

initial begin
    switch0 = 1'b0; switch1 = 1'b0;
    #10 switch0 = 1'b0; switch1 = 1'b0;
    #10 switch0 = 1'b0; switch1 = 1'b1;
    #10 switch0 = 1'b1; switch1 = 1'b0;
    #10 switch0 = 1'b1; switch1 = 1'b1;
    #10 $finish;
end

endmodule