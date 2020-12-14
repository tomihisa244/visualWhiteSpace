module Main where

import Vis
import Parse
import Exec
import System.Environment

main :: IO ()
main = do 
    args <- getArgs
    case args of
        [] -> putStrLn "usage"
        ("-help":[]) -> putStrLn "you can use \"file\" and \"-show\" or, \"-simple-show\" or, \"-simple\" or, \"-vis\" or, \"-trace\""
        (file:[]) -> exec file ""
        (file:option:[]) -> exec file option
        _ ->  putStrLn "usage"