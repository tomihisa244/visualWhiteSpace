module Main where

import Vis
import Parse

main :: IO ()
main = do
    let label0           = "        \n" --0
    let value1           = "       \t\n" --1
    let value2           = "      \t \n" --2
    let value3           = "      \t\t\n" --3
    let setStack         = "  "
    let stackTopCopy     = " \n "
    let stackTopSwap     = " \n\t"
    let stackTopthrow    = " \n\n"
    let add              = "\t   "
    let sub              = "\t  \t"
    let mul              = "\t  \n"
    let div              = "\t \t "
    let mod              = "\t \t\t"
    let valueToAdress    = "\t\t "
    let adressToStack    = "\t\t\t"
    let defLabel         = "\n  "
    let callSubr         = "\n \t"
    let jump             = "\n \n"
    let zeroJump         = "\n\t "
    let negJump          = "\n\t\t"
    let endSubr          = "\n\t\n"
    let fns              = "\n\n\n"
    let outChar          = "\t\n  "
    let outInt           = "\t\n \t"
    let inChar           = "\t\n\t "
    let inInt            = "\t\n\t\t"
    let end              = "\n\n\n"
    let text = setStack ++ value1 ++ setStack ++ value2 ++ add ++ outInt ++ end
    let seme = impParse $ blindToShow text
    tapeParse seme [] [] [] 0 False
    print $ blindToShow text