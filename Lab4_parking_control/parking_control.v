module parking_control#(
    parameter CNT_MAX = 27'd100_000_000
)(
    input clk,
    input switch0,
    input switch1,
    input pushbutton1,
    input pushbutton2,
    output reg LED
);

reg [2:0] state = 3'd0;
reg [2:0] next_state = 3'd0;
localparam idle = 3'd0, car_drivein = 3'd1, enter_password = 3'd2, car_driveoff = 3'd3, open_gate = 3'd4;

reg [26:0] cnt = 0;
wire tick_0_5s = (cnt == CNT_MAX - 1);

always @(posedge clk) begin
    if (tick_0_5s)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

always @(*) begin
    case(state)
        idle:           next_state = car_drivein;
        car_drivein:    next_state = (pushbutton1) ? enter_password : car_driveoff;
        enter_password: next_state = ({switch1, switch0} == 2'b11) ? open_gate : enter_password;
        car_driveoff:   next_state = (pushbutton2) ? open_gate : idle;
        open_gate:      next_state = idle;
        default:        next_state = idle;
    endcase
end

always @(posedge clk) begin
    if (tick_0_5s) begin
        state <= next_state;
    end
end

always @(posedge clk) begin
    if (state == open_gate)
        LED = 1'b1;
    else
        LED = 1'b0;
end

endmodule