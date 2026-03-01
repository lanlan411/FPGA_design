module line_buffer #(
    parameter CNT_MAX = 27'd200_000_000
)(
    input clk,
    input pushbutton3_reset,
    input pushbutton0_start,
    input [3:0] switch,
    output reg [3:0] LED_state
);
    reg [15:0] line_register;
    reg [3:0] width_select;
    reg [26:0] cnt;
    reg start_run;
    wire tick_1s = (cnt == CNT_MAX - 1);

    always @(*) begin
        case(switch)
            4'b0010: width_select = 4'd2;
            4'b0100: width_select = 4'd4;
            4'b1000: width_select = 4'd8;
            default: width_select = 4'd0;
        endcase
    end

    always @(posedge clk or posedge pushbutton3_reset) begin
        if(pushbutton3_reset) begin
            cnt <= 0;
            start_run <= 1'b0;
        end else begin
            if(pushbutton0_start) start_run <= 1'b1;//一定要多設一個暫存器，因為pushbutton0_start是input，如果要加按鈕work的話加這裡
            if (start_run) begin
                if (tick_1s) cnt <= 0;
                else cnt <= cnt + 1;
            end
        end
    end

    always @(posedge clk or posedge pushbutton3_reset) begin
        if(pushbutton3_reset) begin
            line_register <= 16'd0;
        end else if(start_run && tick_1s) begin
            line_register <= {line_register[14:0], 1'b1};
        end
    end

    always @(*) begin
        case(width_select)
            4'd2: LED_state = {line_register[3], line_register[2], line_register[1], line_register[0]};
            4'd4: LED_state = {line_register[5], line_register[4], line_register[1], line_register[0]};
            4'd8: LED_state = {line_register[9], line_register[8], line_register[1], line_register[0]};
            default: LED_state = 4'd0;
        endcase
    end
endmodule