module light_contol(
    input switch1,
    input switch0,
    output reg [3:0] LED_state
);
always@(*)begin
    case({switch1,switch0})
        2'b00:LED_state = 4'b0001;
        2'b01:LED_state = 4'b0011;
        2'b11:LED_state = 4'b1111;
        default:LED_state = 4'b0000; 
    endcase
end
endmodule