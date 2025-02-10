// PRACTICE ASSERTIONS 1

//When signal_a is asserted, signal_b must be asserted, and must remain up until one of thesignals signal_c or signal_d is asserted.
property p1 ;
  @(posedge clk) disable_iff(reset)
  signal_a |-> signal_b ##1 until (signal_c || signal_d);
endproperty

assert property p1 $info("Assertion passed") else $error("Assertion Failed");
  
  
//After signal_a is asserted, signal_b must be deasserted, and must stay down until the next signal_a.
property p2 ;
  @(posedge clk) disable_iff(rst)
  $rose(signal_a) |-> $fell(signal_b) ##1 until ($stable(signal_a));
endproperty
  
//A request should be followed two cycles later by a rising edge of acknowledge. The ack is only allowed to be high for one clock cycle.
property p3;
  @(posedge clk) disable_iff(reset)
  req |-> ##2 $rose(ack) ##1 (!$changed(ack));
endproperty
  
//If signal_a is received while signal_b is inactive, then on the next cycle signal_c must be inactive, and signal_b must be asserted.
property p4;
  @(posedge clk) disable_iff(reset)  
  ($changed(signal_a) && (~signal_b)) |=> (!signal_c && signal_b);
endproperty
 
//signal_a must not rise before the first signal_b.
property p5;
  @(posedge clk) disable_iff(reset) 
  (!($rose(signal_a) && !($past(signal_b,1))));
endproperty
  
//Write an assertion to check divide by 2 circuit output.(Nothing but T_ff;
property p6;
  @(posedge clk) disable_iff(reset)
  q != $past(q,1); 
endproperty
  
//When the positive edge of signal "a" is detected, check signal "b" has to be high continuously until signal "c" goes low.
property p7;
  @(posedge clk) disable_iff(reset)
  $rose(signal_a) |=> signal_b throughout (!signal_c[->1]);
endproperty
  
//Whenever valid signal goes high enable signal should be asserted in the next cycle & it should be stable till ready signal is asserted. The ready signal should be asserted after enable with in 4 to 6 cycles.
property p8;
  @(posedge clk) disable_iff(reset)
  $rose(valid) |-> enable [*4:6] ##1 ready ;
endproperty
  
//Whenever the signal A goes high from the next cycle the signal B should repeat n no. of times, where n is equal to value of bit[3:0]C when signal A is asserted.
property p9;
  int local , count ;
  @(posedge clk) disable_iff(reset)
  ($rose(a), local = c, count = 0) |=> $rose(b) ##1(b, count++)[*1 : $] ##1 (!b && (count == local-1));
endproperty
 
//Req must eventually be followed by ack, which must be followed 1 cycle later by done.
property p10;
  @(posedge clk) disable_iff(reset)
  req |-> ##[*1:$] ack && ##1 done ;
endproperty
