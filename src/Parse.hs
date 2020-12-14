module Parse where

import Tran
import Vis
import Tokn
import Runner
import Control.Monad.ST
import Data.STRef
import System.Process

-- imp
impParse:: [Token]-> [Semantic]
impParse []  = []
impParse [_] = [ParseError]
impParse (h:s:rest) = case h of
        S -> stackControl (s:rest)
        T -> case s of 
            S  -> integerArithmetic rest
            T  -> heapAccess rest
            LF -> inputOutput rest
            _ -> [ParseError]
        LF -> flowControl (s:rest)
        _ -> [ParseError]


-- command
stackControl::[Token]->[Semantic]
stackControl [] = [ParseError]
stackControl (h:s:rest) = case h of
                    S -> let (num, r) = readNum (s:rest) in
                        (SetStackTop num):(impParse r)
                    T -> case s of
                        S  -> let (num, r) = readNum rest in
                            (NthCopytoSetStackTop num):(impParse r)
                        LF -> let (num, r) = readNum rest in
                            (RemoveNthInStack num):(impParse r)
                        _ -> [ParseError]
                    LF -> case s of
                        S  -> CopyStackTop:(impParse rest)
                        T  -> SwapStackTopSec:(impParse rest)
                        LF -> ThrowStackTop:(impParse rest)
                        _ -> [ParseError]
                    _ -> [ParseError]

-- arithmetic
integerArithmetic::[Token]->[Semantic]
integerArithmetic (h:s:rest) = case h of
    S -> case s of
            S  -> Add:(impParse rest)
            T  -> Sub:(impParse rest)
            LF -> Mul:(impParse rest)
            _ -> [ParseError]
    T -> case s of
            S -> Div:(impParse rest)
            T -> Mod:(impParse rest)
            _ -> [ParseError]
    LF -> [ParseError]

-- heap
heapAccess::[Token]->[Semantic]
heapAccess [] = [ParseError]
heapAccess (h:rest) = case h of 
    S -> ValueToAdress:(impParse rest)
    T -> ValueToStackTop:(impParse rest)
    _ -> [ParseError]

    
-- flowControl
flowControl::[Token]->[Semantic]
flowControl [] = [ParseError]
flowControl [_] = [ParseError]
flowControl (h:s:rest) = case h of
    S -> case s of
        S -> let (label, r) = readLabel rest in
            (DefLabel label):(impParse r)
        T -> let (label, r) = readLabel rest in
            (Subroutine label):(impParse r)
        LF -> let (label, r) = readLabel rest in
            (JumpLabel label):(impParse r)
        _ -> [ParseError]
    T -> case s of 
        S ->  let (label, r) = readLabel rest in
            (IfStackTopisZeroThenJump label):(impParse r)
        T ->  let (label, r) = readLabel rest in
                (IfStackTopisNegThenJump label):(impParse r)
        LF -> FinishSubroutine:(impParse rest)
        _ -> [ParseError]
    LF -> case s of 
        LF -> FinishProgram:(impParse rest)
        _ -> [ParseError]
    _ -> [ParseError]

-- IO
inputOutput::[Token]->[Semantic]
inputOutput (h:s:rest) = case h of
    S -> case s of
        S ->StackTopOutChar:(impParse rest)
        T ->StackTopOutInt:(impParse rest)
        _ ->[ParseError]
    T -> case s of
        S ->ReadCharToAdress:(impParse rest)
        T ->ReadIntToAdress:(impParse rest)
        _ ->[ParseError]
    _ -> [ParseError]

readNum::[Token]->(Value,[Token])
readNum t = (num, rest)
    where
        num = tranNum $ takeWhile (/=LF) t
        rest = tail $ dropWhile (/=LF) t

readLabel::[Token]->(Label,[Token])
readLabel t = (label,rest)
    where 
        label = showtoken $ takeWhile (/=LF) t
        rest = tail $ dropWhile (/=LF) t

tapeParse::[Semantic]->Stack->CallStack->Heap->Integer->Bool->IO ()
tapeParse [] _ _ _ _ _ = return ()
tapeParse [x] _ _ _ _ _ = case x of 
                    FinishProgram        -> return () 
                    _                    -> print $ (ParseError:x:[])
tapeParse tape stack cstack heap pc trace = do
                        if trace 
                            then 
                                do
                                    system "cls"
                                    putStrLn $ "prg         : " ++ show (tape !! (fromIntegral pc))
                                    putStrLn $ "stack       : " ++ show stack
                                    putStrLn $ "call stack  : " ++ show cstack
                                    putStrLn $ "heap        : " ++ show heap
                                    putStrLn $ "pc          : " ++ show pc
                                    -- _ <- getLine
                                    putStrLn ""
                            else return ()
                        case tape !! (fromIntegral pc) of
                                ParseError             -> print ParseError
                                SetStackTop x          -> tapeParse tape (push stack x) cstack heap (pc+1) trace
                                NthCopytoSetStackTop x -> tapeParse tape (copyNth stack x) cstack heap (pc+1) trace
                                RemoveNthInStack x     -> tapeParse tape (rmNth stack x) cstack heap (pc+1) trace
                                CopyStackTop           -> tapeParse tape (copyTop stack) cstack heap (pc+1) trace
                                SwapStackTopSec        -> tapeParse tape (swapTS stack) cstack heap (pc+1) trace
                                ThrowStackTop          -> tapeParse tape (throwTop stack) cstack heap (pc+1) trace
                                Add                    -> tapeParse tape (wsAdd stack) cstack heap (pc+1) trace
                                Sub                    -> tapeParse tape (wsSub stack) cstack heap (pc+1) trace
                                Mul                    -> tapeParse tape (wsMul stack) cstack heap (pc+1) trace
                                Div                    -> tapeParse tape (wsDiv stack) cstack heap (pc+1) trace
                                Mod                    -> tapeParse tape (wsMod stack) cstack heap (pc+1) trace
                                StackTopOutChar        -> do 
                                                            outChar $ head stack
                                                            tapeParse tape (tail stack) cstack heap (pc+1) trace
                                StackTopOutInt         -> do 
                                                            outInt $ head stack 
                                                            tapeParse tape (tail stack) cstack heap (pc+1) trace
                                ReadIntToAdress       -> do 
                                                            iheap <- inInt (head stack) heap
                                                            tapeParse tape (tail stack) cstack iheap (pc+1) trace
                                ReadCharToAdress        -> do 
                                                            cheap <- inChar (head stack) heap
                                                            tapeParse tape (tail stack) cstack cheap (pc+1) trace
                                ValueToStackTop     -> do
                                                            rHeap <- readHeap (head stack) heap
                                                            tapeParse tape (rHeap:(tail stack)) cstack heap (pc+1) trace
                                ValueToAdress       -> do
                                                            sHeap <- storeHeap (head stack) (stack !! 1) heap
                                                            tapeParse tape (drop 2 stack) cstack sHeap (pc+1) trace
                                DefLabel x              -> tapeParse tape stack cstack heap (pc+1) trace
                                Subroutine x            -> do 
                                                            loc <- findLabel x tape
                                                            tapeParse tape stack (pc:cstack) heap loc trace
                                FinishSubroutine        -> tapeParse tape stack (tail cstack) heap (head cstack+1) trace
                                JumpLabel x             -> do
                                                            loc <- findLabel x tape
                                                            tapeParse tape stack cstack heap loc trace
                                IfStackTopisZeroThenJump x -> do
                                                            loc <- findLabel x tape
                                                            if head stack == 0 
                                                                then tapeParse tape (tail stack) cstack heap loc trace
                                                                else tapeParse tape (tail stack) cstack heap (pc+1) trace
                                IfStackTopisNegThenJump x -> do
                                                            loc <- findLabel x tape
                                                            if head stack < 0
                                                                then tapeParse tape (tail stack) cstack heap loc trace
                                                                else tapeParse tape (tail stack) cstack heap (pc+1) trace
                                FinishProgram -> return ()