module counter(
    input clk,
    input reset,
    input C,
    output reg [2:0] LED_state
);

reg [2:0] next_state;

always@(*)begin
    next_state = LED_state;
        case(LED_state)    
            3'd7:if(C) next_state = 3'd0;
            3'd0:if(~C) next_state = 3'd1;
            3'd1:if(C) next_state = 3'd2;
            3'd2:if(~C) next_state = 3'd4;
            3'd4:if(C) next_state = 3'd5;
            3'd5:if(~C) next_state = 3'd6;
            3'd6:if(C) next_state = 3'd0;
            3'd3:if(~C) next_state = 3'd4;
            default:next_state = 3'd0;
        endcase
end

always@(posedge clk or posedge reset)begin
    if(reset)
        LED_state <= 3'd7;
    else
        LED_state <= next_state;
end

endmodule