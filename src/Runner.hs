module Runner where

import Tokn
import Data.Char
import System.IO

--stack
push::Stack->Value->Stack
push stack x = ([x]++stack)

copyNth::Stack->Integer->Stack
copyNth stack n = [stack !! (fromIntegral n)] ++ stack

rmNth::Stack->Integer->Stack
rmNth stack n = take (fromIntegral n) stack ++ drop (fromIntegral n+1) stack

copyTop::Stack->Stack
copyTop stack = [head stack] ++ stack

swapTS::Stack->Stack
swapTS stack = [sec] ++ [top] ++ drop 2 stack
    where 
        top = head stack
        sec = stack !! 1

throwTop::Stack->Stack
throwTop stack = tail stack

--Arithmetic
wsAdd::Stack->Stack
wsAdd stack = [s + t] ++ drop 2 stack
        where 
            t = head stack
            s = stack !! 1

wsSub::Stack->Stack
wsSub stack = [s - t] ++ drop 2 stack
        where 
            t = head stack
            s = stack !! 1

wsMul::Stack->Stack
wsMul stack = [s * t] ++ drop 2 stack
        where 
            t = head stack
            s = stack !! 1

wsDiv::Stack->Stack
wsDiv stack = [div s t] ++ drop 2 stack
        where 
            t = head stack
            s = stack !! 1

wsMod::Stack->Stack
wsMod stack = [mod s t] ++ drop 2 stack
        where 
            t = head stack
            s = stack !! 1

--IO
outChar::Integer->IO ()
outChar c = do
    putChar $ toEnum $ fromIntegral c
    hFlush stdout

outInt::Integer->IO ()
outInt i = do
    putStr $ show i
    hFlush stdout

inChar::Integer->Heap->IO Heap
inChar loc heap = do
                c <- fromIntegral . fromEnum <$> getChar
                storeHeap c loc heap

inInt::Integer->Heap->IO Heap
inInt loc heap = do
                i <- readLn
                storeHeap i loc heap

--heap
readHeap :: Integer -> Heap -> IO Integer
readHeap loc heap = return (heap !! (fromIntegral loc))

storeHeap :: Integer -> Integer -> Heap -> IO Heap
storeHeap x 0 (h:heap) = return (x:heap)
storeHeap x loc (h:heap) = do 
                            wHeap <- storeHeap x (loc-1) heap
                            return (h:wHeap)
storeHeap x 0 [] = return (x:[])
storeHeap x loc [] = do
                        wHeap <- storeHeap x (loc-1) []
                        return (0:wHeap)

findLabel :: Label -> [Semantic] -> IO Integer
findLabel label tape = findLabel' label tape 0

findLabel' :: Label -> [Semantic] -> Integer -> IO Integer
findLabel' label [] _ = fail $ "Undefind label (" ++ show label ++ ")"
findLabel' label ((DefLabel l):rest) i
    | label == l = return i
    | otherwise = findLabel' label rest (i+1)
findLabel' label (_:rest) i = findLabel' label rest (i+1)