module Tran where
import Data.List
import Data.Char
import Tokn

tranNum::[Token] -> Value
tranNum = bToi . map zeroOne

zeroOne::Token->Value
zeroOne t = case t of 
    S -> fromIntegral $ fromEnum S
    T -> fromIntegral $ fromEnum T

bToi::[Value]->Value
bToi (x:xs) = if x == 0 then foldl (\x y -> 2*x + y) 0 xs
                        else -(foldl (\x y -> 2*x + y) 0 xs)

intToLabel::Value -> Label
intToLabel 0 = "S"
intToLabel 1 = "T"
intToLabel label = if m == 0 then intToLabel dlabel ++ "T" else intToLabel dlabel ++ "S"
                where 
                    m = label `mod` 2
                    dlabel = div label 2