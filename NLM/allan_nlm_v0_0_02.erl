-module(allan_nlm_v0_0_02).
-behaviour(gen_statem).

-export([stop/0, start_link/0]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).
-export([input_integer/0,right_input/0,initialization/0,rshifting/0,rtransform/0,red_result/0,yshifting/0,ytransform/0,mul_result/0,rreturn/0]).

stop() ->
    gen_statem:stop(?MODULE).

start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).
input_integer() ->
    gen_statem:call(?MODULE, input_integer).
right_input() ->
    gen_statem:cast(?MODULE, right_input).
initialization() ->
    gen_statem:cast(?MODULE, initialization).
rshifting() ->
    gen_statem:cast(?MODULE, rshifting).
rtransform() ->
    gen_statem:cast(?MODULE, rtransform).
red_result() ->
    gen_statem:cast(?MODULE, red_result).
yshifting() ->
    gen_statem:cast(?MODULE, yshifting).
ytransform() ->
    gen_statem:cast(?MODULE, ytransform).
mul_result() ->
    gen_statem:cast(?MODULE, mul_result).
rreturn() ->
    gen_statem:cast(?MODULE, rreturn).
init(_Args) ->
    {ok, wait, []}.

%% state_functions | handle_event_function | [_, state_enter].
callback_mode() ->
    handle_event_function.

handle_event({call,From}, input_integer, wait, _Data) ->
    
    {ok, First_Integer} = io:read("First_Integer: "),
    {ok, Second_Integer} = io:read("Second_Integer: "),
    List_Input = First_Integer, Second_Integer,
    allan_nlm_v0_0_02:right_input(),
    {
    next_state,{right_input, List_Input,First_Integer,Second_Integer},_Data,[{reply, From, ok}]
    };
handle_event(cast, right_input, {right_input,List_Input,First_Integer,Second_Integer}, _Data) ->
    case List_Input of 
    List_Input when List_Input >= 0, List_Input =< 281474976710655 ->
    io:format("First_Integer: ~p~n", [First_Integer]),
    io:format("Second_Integer: ~p~n", [Second_Integer]),
    allan_nlm_v0_0_02:initialization(),
    {
    next_state,{initialization, First_Integer, Second_Integer},_Data
    };

_else ->
    io:format("Invalid input! Please enter a valid integer.~n"),

    {
    next_state, wait,_Data
    }
end;
handle_event(cast, initialization, {initialization,First_Integer,Second_Integer}, _Data) ->
    F1 = 59032325644659,
    F2 = 1,
    Red1 = F1 bxor F2,
    Red0 = 0,
    Mul1 = First_Integer,
    Mul0 = 0,
    Bit_List = "000000000000000000000000000000000000000000000000",
    R = 0,
    Rotation = 0,
    allan_nlm_v0_0_02:rshifting(),
    {
    next_state,{rshifting, Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R,Rotation},_Data
    };
handle_event(cast,rshifting,{rshifting,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R,Rotation}, _Data) ->
    R_Binarize_List_Slice_Reverse = lists:reverse(string:slice(lists:reverse(Bit_List ++ binary_to_list(integer_to_binary(R, 2))), 0, 48)),
    R_Binarize_List_Slice_Reverse_Concatenate_Rotate = lists:nthtail(1, R_Binarize_List_Slice_Reverse) ++ lists:sublist(R_Binarize_List_Slice_Reverse, 1),
    io:format("| ~p |",[R_Binarize_List_Slice_Reverse_Concatenate_Rotate]),
    allan_nlm_v0_0_02:rtransform(),
    {  
    next_state,{rtransform, Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate,Rotation},_Data
    };
handle_event(cast, rtransform,{rtransform,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate,Rotation}, _Data) ->
    R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number = binary_to_integer(list_to_binary(R_Binarize_List_Slice_Reverse_Concatenate_Rotate),2),
    R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band = R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number band 1,
    allan_nlm_v0_0_02:red_result(),
    {
    next_state,{red_result,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band,Rotation},_Data
    };
handle_event(cast, red_result, {red_result,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band,Rotation}, _Data) ->
    case R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band of 
        0 -> R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result  = R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number bxor Red0;
        1 -> R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result  = R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number bxor Red1
    end,

    allan_nlm_v0_0_02:yshifting(),
    {
    next_state,{yshifting,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Rotation},_Data
    };
handle_event(cast, yshifting, {yshifting,Second_Integer,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Rotation}, _Data) ->
    Second_Integer_Binarize_List_Slice_Reverse = lists:reverse(string:slice(lists:reverse(Bit_List ++ binary_to_list(integer_to_binary(Second_Integer, 2))), 0, 48)),
    Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate = lists:nthtail(1, Second_Integer_Binarize_List_Slice_Reverse) ++ lists:sublist(Second_Integer_Binarize_List_Slice_Reverse, 1),
    io:format("|~p |",[Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate]),
    allan_nlm_v0_0_02:ytransform(),
    {
    next_state,{ytransform,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Rotation},_Data
    };
handle_event(cast, ytransform, {ytransform,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Rotation}, _Data) ->
    Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number = binary_to_integer(list_to_binary(Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate), 2),
    Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band = Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number band 1,
    allan_nlm_v0_0_02:mul_result(),
    {
    next_state,{mul_result,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band,Rotation},_Data
    };
handle_event(cast, mul_result, {mul_result,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band,Rotation}, _Data) ->
    case Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band of
        0 -> R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish = R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result bxor Mul0;
        1 -> R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish = R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result bxor Mul1
    end,
    io:format("| ~*w | ",[20,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish]),
    io:format("Hexa: ~*s ~n", [14,binary_to_list(integer_to_binary(R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish, 16))]),
    allan_nlm_v0_0_02:rreturn(),
    {
    next_state,{rreturn, Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish,Rotation},_Data
    };
handle_event(cast, rreturn, {rreturn,Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish,Rotation}, _Data) ->
    case Rotation of
        48 -> 
           {
        next_state, wait, _Data
        };
    
    _else ->
    allan_nlm_v0_0_02:rshifting(),
    {
    next_state,{rshifting, Second_Integer_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number,Red1,Red0,Mul1,Mul0,Bit_List,R_Binarize_List_Slice_Reverse_Concatenate_Rotate_Number_Band_Result_Finish,Rotation + 1},_Data
    }
    end.
terminate(_Reason, _State, _Data) ->
    ok.

code_change(_OldVsn, State, Data, _Extra) ->
    {ok, State, Data}.
