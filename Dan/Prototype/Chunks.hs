module Chunks where

-------------------------------------------------------------------------------
-- Chunks!
-------------------------------------------------------------------------------
import InternalAST
import Config
import System.IO
import System.Directory
import System.Environment
import Data.List
import Data.Char
import Control.Monad

data Chunk = Chunk Ref [Definition]
  deriving (Eq, Show, Read)
type Ref = String

contains (t:ts) d = (contains ts d) && (any ((==t) . fst) $ d)
contains [] _ = True

makeChunk d = Chunk (createRef d) d

createRef :: [Definition] -> Ref
createRef (d:ds) = if ((fst d) == refHeader)
                  then snd d 
                  else createRef ds
createRef [] = error "Definition list missing the reference header"

hasRef (Chunk ref _) = \r -> r == ref

parseChunk filename = makeChunk `fmap` (makeDefs filename)

makeDefs filename = do
  str1 <- readFile (buildPath ++ filename)
  let results = parseDefs (lines str1)
  return results
  

parseDefs :: [String] -> [Definition]
parseDefs (l:ls) = 
 if ((head l) == '@')
   then [((drop 1 l),(define ls))] ++ (parseDefs ls)
   else parseDefs ls
parseDefs [] = []

define (l:ls) = 
  if (not(head l == '@'))
    then l ++ (define ls)
    else []
define [] = []