module Vis where
    
import Control.Monad
import Data.List
import Tokn

visualization::Char->Token
visualization c = case c of
    ' ' -> S
    '\t' -> T
    '\n' -> LF
    _ -> Ig
    
blindToShow::String->[Token]
blindToShow = filter (/= Ig) . map visualization

inVisualization::Token->String
inVisualization c = case c of
    S -> " "
    T -> "\t"
    LF -> "\n"
    Ig-> ""

showToBlind::[Token]->String
showToBlind = foldl1 (++) . filter (/= "") . map inVisualization

simpleInVis::Char->String
simpleInVis c = case c of
    'S' -> " "
    'T' -> "\t"
    '\n' -> "\n"
    _ -> ""

simpleStoB::String->String
simpleStoB = foldl1 (++) . filter (/= "") . map simpleInVis

semaShow::[Semantic]->IO ()
semaShow sema = mapM_ print sema

showtoken::[Token]->String
showtoken [] = ""
showtoken (x:xs) = case x of
                        S -> "S" ++ showtoken xs
                        T -> "T" ++ showtoken xs
                        LF -> "LF\n" ++ showtoken xs
                        _ -> "" ++ showtoken xs