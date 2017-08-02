{-# LANGUAGE GADTs #-}

module Language.Drasil.DataDesc where

import Language.Drasil.Chunk.Code
import Language.Drasil.Chunk.Quantity
import Language.Drasil.Chunk.SymbolForm

import Data.List (nub)

type DataDesc = [Data]

type DataItem = CodeChunk

data Entry = Entry DataItem             -- regular entry (float, int, bool, etc)
           | ListEntry [Ind] DataItem   -- index to insert into list
           | JunkEntry                  -- junk should be skipped in input file

data Ind = Explicit Int   -- explicit index
         | WithPattern    -- use current repetition number in repeated pattern
         | WithLine       -- use current line number in multi-line data
           
type Delim = Char  -- delimiter
  
data Data = Singleton DataItem
          | JunkData
          | Line LinePattern Delim
          | Lines LinePattern (Maybe Int) Delim -- multi-line data
                                                -- (Maybe Int) = number of lines, Nothing = unknown so go to end of file  
          
data LinePattern = Straight [Entry]             -- line of data with no pattern
                 | Repeat [Entry] (Maybe Int)   -- line of data with repeated pattern
                                                -- (Maybe Int) = number of repetitions, Nothing = unknown so go to end of line          

                                            

entry :: (Quantity c, SymbolForm c) => c -> Entry
entry c = Entry $ codevar c

listEntry :: (Quantity c, SymbolForm c) => [Ind] -> c -> Entry
listEntry i c = ListEntry i $ codevar c

junk :: Entry
junk = JunkEntry

singleton :: (Quantity c, SymbolForm c) => c -> Data
singleton c = Singleton $ codevar c

junkLine :: Data
junkLine = JunkData

singleLine :: LinePattern -> Delim -> Data
singleLine = Line 

multiLine :: LinePattern -> Delim -> Data
multiLine l d = Lines l Nothing d 

multiLine' :: LinePattern -> Int -> Delim -> Data
multiLine' l i d = Lines l (Just i) d 

straight :: [Entry] -> LinePattern
straight = Straight

repeated :: [Entry] -> LinePattern
repeated e = Repeat e Nothing

repeated' :: [Entry] -> Int -> LinePattern
repeated' e i = Repeat e (Just i)



getInputs :: DataDesc -> [CodeChunk]
getInputs d = nub $ concatMap getDataInputs d
  where getDataInputs (Singleton v) = [v]
        getDataInputs (Line lp _) = getPatternInputs lp
        getDataInputs (Lines lp _ _) = getPatternInputs lp
        getDataInputs JunkData = []
        getPatternInputs (Straight e) = concatMap getEntryInputs e
        getPatternInputs (Repeat e _) = concatMap getEntryInputs e
        getEntryInputs (Entry v) = [v]
        getEntryInputs (ListEntry _ v) = [v]
        getEntryInputs JunkEntry = []        