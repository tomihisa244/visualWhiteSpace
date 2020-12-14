module Tokn where

data Token      = S | T | LF | Ig deriving (Show, Eq, Enum)
type Value      = Integer
type Stack      = [Integer]
type Heap       = [Integer]
type CallStack  = [Integer]
type Label      = String
data Semantic   = SetStackTop Integer
                | NthCopytoSetStackTop Integer
                | RemoveNthInStack Integer
                | CopyStackTop
                | SwapStackTopSec
                | ThrowStackTop
                | Add
                | Sub
                | Mul
                | Div
                | Mod
                | StackTopOutChar
                | StackTopOutInt
                | ReadCharToAdress
                | ReadIntToAdress
                | ValueToAdress
                | ValueToStackTop
                | DefLabel Label
                | Subroutine Label
                | JumpLabel Label
                | IfStackTopisZeroThenJump Label
                | IfStackTopisNegThenJump Label
                | FinishSubroutine
                | FinishProgram
                | ParseError
                deriving (Show, Eq)