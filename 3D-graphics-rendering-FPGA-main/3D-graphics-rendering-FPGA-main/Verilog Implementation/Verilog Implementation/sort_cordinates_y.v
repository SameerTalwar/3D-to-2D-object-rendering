module sort_cordinates_y(
	input signed [16-1:0] vi_1x ,
	input signed [16-1:0] vi_1y ,
	input signed [16-1:0] vi_2x ,
	input signed [16-1:0] vi2_2y ,	
	input signed [16-1:0] vi_3x ,
	input signed [16-1:0] vi_3y,
	
	output signed [16-1:0] vo_1x ,
	output signed [16-1:0] vo_1y ,
	output signed [16-1:0] vo_2x ,
	output signed [16-1:0] vo_2y ,	
	output signed [16-1:0] vo_3x ,
	output signed [16-1:0] vo_3y );


function unsigned [3-1:0] minloc ( unsigned[3-1:0] count1 ) ;
      unsigned [3-1:0] minloc ;
      minloc = count1 ;
      integer [32-1:0] minval ;
      minval = inp_arr[ count1 ] ;
      for (integer i = 0 ; i < 8 ; i = i+1)
         if ( i > count1 ) begin
	   if ( inp_arr [ i ] <  minval )  begin
             minval = inp_arr [ i ] ;
             minloc = fromInteger(i) ;
           end 
         end 

endfunction

always @(*) begin

if ( rg_busy && count < 7 ) begin
     integer [32-1:0] inp_arr_local[8] ;
     integer [32-1:0] temp_reg;
     // use this array of int32 variables to read and modify the contents of 
     // array "inp_arr" of 8 int32.

     // read inp_arr contents into inp_arr_local
     for ( integer i = 0; i<8; i=i+1 ) inp_arr_local[i] = inp_arr[i] ;  
     // note "=" that is "assignment to variable" 
     //  and **not** an "assignment to a storage element" , i.e. **not** "<="
     
     // modify array of variables ( combinational ) in order to perform swap
     temp_reg = inp_arr_local[ count ] ;
     inp_arr_local[ count ]  = inp_arr_local[minloc(count)];
     inp_arr_local[ minloc(count) ] = temp_reg;

     // update array "inp_arr" of 8 int32 registers 
     for ( Integer i = 0; i<8; i=i+1 ) inp_arr[i] = inp_arr_local[i]  ;  

     // do not forget to update the storage count
     count = count + 1 ;

end

endmodule
