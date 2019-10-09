(* TODO: open Binary *)

(* type *)

type bit = Zero | One

type peanoType = Zero | Successor

type parenType = Open_paren | Close_paren

(* init *)

let zflag : bit = Zero
let sflag : bit = Zero
let openParenFlag : bit = Zero
let closeParenFlag : bit = Zero

(* func *)

let readPeanoFlag bit peanoType = function
  | (bit, Zero) -> zflag = bit
  | (bit, Successor) -> sflag = bit

let readParenFlag bit parenType = function
  | (bit, Open_paren) -> openParenFlag = bit
  | (bit, Close_paren) -> closeParenFlag = bit

let parsePeano peanoType = match peanoType with
  | Zero -> ()
  | Successor -> ()

let parseParen parenType = match parenType with
  | Open_paren  -> ()
  | Close_paren  -> ()

let invalid_token =
  raise (Failure "Invalid token read")

let read_input (str:string) =
  let len = String.length str in
  for i = 0 to len - 1 do
    match str . [i] with
    | 'Z' -> parsePeano Zero
    | 'S' -> parsePeano Successor
    | '(' -> parseParen Open_paren
    | ')' -> parseParen Close_paren
    | _ -> invalid_token
  done
