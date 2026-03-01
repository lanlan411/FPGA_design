module FSM #(
    parameter CNT_MAX = 27'd100_000_000
)(
    input clk,
    input pushbutton0_reset,
    input pushbutton1_x,
    output reg [1:0] LED_state
);

reg [26:0] cnt;
wire tick_0_5s = (cnt == CNT_MAX);

always @(posedge clk or posedge pushbutton0_reset) begin
        if (pushbutton0_reset)
            cnt <= 0;
        else if (tick_0_5s)
            cnt <= 0;
        else
            cnt <= cnt + 1;
end

reg [1:0] next_state;
always@(*)begin
    case(LED_state)
        2'd0:next_state = (pushbutton1_x)? 2'd1:2'd0;
        2'd1:next_state = (pushbutton1_x)? 2'd2:2'd1;
        2'd2:next_state = (pushbutton1_x)? 2'd3:2'd2;
        2'd3:next_state = (pushbutton1_x)? 2'd0:2'd3;
        default:next_state = 2'd0;
    endcase
end

always@(posedge clk or posedge pushbutton0_reset)begin
    if(pushbutton0_reset)
        LED_state <= 2'd0;
    else if(tick_0_5s)
        LED_state <= next_state;
end
endmodule