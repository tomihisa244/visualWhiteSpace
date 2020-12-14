module Exec where

import Tokn
import Vis
import Parse

exec::String->String->IO ()
exec file option = do
    code <- readFile file
    let sema = impParse $ blindToShow code
    case option of
        "-help"             -> putStrLn "you can use -show -simple -vis -trace"
        "-show"             -> putStr $ showtoken $ blindToShow code
        "-simple-show"      -> putStr $ simpleStoB code
        "-simple"           -> tapeParse (impParse $ blindToShow $ simpleStoB code) [] [] [] 0 False
        "-vis"              -> semaShow sema
        "-trace"            -> tapeParse sema [] [] [] 0 True
        _ -> tapeParse sema [] [] [] 0 False