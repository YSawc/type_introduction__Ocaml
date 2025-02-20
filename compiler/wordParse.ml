open LetterAnalyse

(* TODO:
 * call types from module *)

type preExprTokens_t = {
  d_LLPeano : string;
  d_LRPeano : string;
  d_RPeano : string;
  d_LCalcExpr : string;
  d_RCalcExpr : string;
}

type wordType =
  | Peano
  | Operation

type operatorType =
  | Plus
  | Times

type operatorData =
  { name: string
  ; operator : operatorType
  }

let operatorDatas =
  [ { name = "plus"; operator = Plus }
  ; { name = "times"; operator = Times }
  ]

let _LLPeano = ref ""
let _LRPeano = ref ""
let _RPeano = ref ""

let _LCalcExpr = ref ""
let _RCalcExpr = ref ""

let readPeanoIndex = ref 0

let readCalcIndex = ref 0

let initReadPeanos =
  _LLPeano := ""
  ;
  _LRPeano := ""
  ;
  _RPeano := ""

let initReadCalcExpr =
  _LCalcExpr := ""
  ;
  _RCalcExpr := ""

let preExprTokens =
  ref
    { d_LLPeano = ""
    ; d_LRPeano = ""
    ; d_RPeano = ""
    ; d_LCalcExpr = ""
    ; d_RCalcExpr = ""
    ;}

let setPreExprTokens
    (a_LLPeano:string)
    (a_LRPeano:string)
    (a_RPeano:string)
    (a_LCalcExp:string)
    (a_RCalcExp:string)
  =
  preExprTokens :=
    { d_LLPeano = a_LLPeano
    ; d_LRPeano = a_LRPeano
    ; d_RPeano = a_RPeano
    ; d_LCalcExpr = a_LCalcExp
    ; d_RCalcExpr = a_RCalcExp
    }

let parseWords (words:string) : string list =
  Str.split (Str.regexp " " ) words

let parsePeanoSyntax (peano:string) =
  read_input @@ peano

let rec operatorDetector (rowWord:string) (operatorDatas) =
  (
    match operatorDatas with
    | [] -> raise (Failure "Invalid word detected with [] .")
    | { name = n; operator = _} :: rest ->
      (
        if rowWord = n
        then
          (
            (
              match !readCalcIndex with
              | 0 -> _LCalcExpr := n
              | 1 -> _RCalcExpr := n
              | _ -> raise (Failure "Total expr number is wrong! Please fix form like n1 expr n2 expr n3.")
            );
            readCalcIndex := !readCalcIndex + 1
          );
        operatorDetector rowWord rest
      )
  );
  if !readCalcIndex <> 1
  then
    raise (Failure "Total expr number is wrong! Please fix form like n1 expr n2 expr n3.")

let parseWord (rowStr:string) =
  match rowStr . [0] with
  | 'S' | 'Z' ->
    parsePeanoSyntax @@ rowStr
    ;
    (
      match !readPeanoIndex with
      | 0 -> _LLPeano := rowStr
      | 1 -> _LRPeano := rowStr
      | 2 -> _RPeano := rowStr
      | _ -> raise (Failure "Total peano number is wrong! Please fix form like n1 expr n2 expr n3.")
    );
    readPeanoIndex := !readPeanoIndex + 1
  | _ ->
    operatorDetector rowStr operatorDatas

let parseDetector (rowStr:string) =
  let rowStrList = parseWords @@ rowStr in
  let len = List.length rowStrList in
  for i = 0 to len - 1 do
    parseWord @@ List.nth rowStrList i
  done

let initDetector =
  readPeanoIndex := 0
  ;
  initReadPeanos
  ;
  readCalcIndex  := 0
  ;
  initReadCalcExpr

let callInferenceChecker = function
  | ("plus", 'Z') -> ()
  | ("plus", 'S') -> ()
  | ("plus", _) -> ()
  | ("times", 'Z') -> ()
  | ("times", 'S') -> ()
  | ("times", _) -> ()
  | (_, _) -> raise (Failure "Some thing is wrong detected with parsedWord! Please check your input.")

let wordParser (rowStr:string) =
  rowStr |> parseDetector
  ;
  setPreExprTokens
    (!_LLPeano)
    (!_LRPeano)
    (!_RPeano)
    (!_LCalcExpr)
    (!_RCalcExpr)
  ;
  initDetector
  ;

