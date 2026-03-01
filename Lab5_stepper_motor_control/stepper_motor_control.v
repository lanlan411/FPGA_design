module stepper_motor_control#(
    parameter CNT_MAX = 27'd100_000_000
)(
    input clk,
    input pushbutton1_reset,
    input switch0,
    output reg [1:0] LED_state
);
reg [1:0] next_state;

reg [26:0] cnt = 0;
wire tick_0_5s = (cnt == CNT_MAX - 1);

always @(posedge clk or posedge pushbutton1_reset) begin
    if(pushbutton1_reset)
        cnt <= 0;
    else if (tick_0_5s)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

always@(posedge clk or posedge pushbutton1_reset)begin
    if(pushbutton1_reset)
        LED_state <= 2'd0;
    else if(tick_0_5s)
        LED_state <= next_state;
end

always@(*)begin
    case({switch0,LED_state})
        3'b000:next_state = 2'b01;
        3'b001:next_state = 2'b11;
        3'b011:next_state = 2'b10;
        3'b010:next_state = 2'b00;

        3'b100:next_state = 2'b10;
        3'b110:next_state = 2'b11;
        3'b111:next_state = 2'b01;
        3'b101:next_state = 2'b00;
        default:next_state = 2'b00;
    endcase
end


endmodule