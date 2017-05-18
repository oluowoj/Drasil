module Language.Drasil.Generate (gen, genCode) where

import System.IO
import Text.PrettyPrint.HughesPJ
import Prelude hiding (id)
import System.Directory
import Language.Drasil.Output.Formats (DocType (SRS,MG,MIS,LPM,Website))
import Language.Drasil.TeX.Print (genTeX)
import Language.Drasil.HTML.Print (genHTML)
import Language.Drasil.HTML.Helpers (makeCSS)
import Language.Drasil.Code.Import (toCode)
import Language.Drasil.Make.Print (genMake)
import Language.Drasil.Document
import Language.Drasil.Format(Format(TeX, HTML))
import Language.Drasil.Recipe(Recipe(Recipe))
import Language.Drasil.Chunk.Module
import Language.Drasil.Chunk
import Language.Drasil.Chunk.NamedIdea (NamedIdea)
import Language.Drasil.Code.Imperative.LanguageRenderer
  hiding (body)
import Language.Drasil.Code.Imperative.Helpers
import Control.Lens

-- temporary
import Language.Drasil.Code.CodeGeneration
import Language.Drasil.Code.Imperative.Parsers.ConfigParser

-- | Generate a number of artifacts based on a list of recipes.
gen :: [Recipe] -> IO ()
gen rl = mapM_ prnt rl

-- | Generate the output artifacts (TeX+Makefile or HTML)
prnt :: Recipe -> IO ()
prnt (Recipe dt@(SRS _) body) =
  do prntDoc dt body
     prntMake dt
prnt (Recipe dt@(MG _) body) =
  do prntDoc dt body
     prntMake dt
--     prntCode body
prnt (Recipe dt@(MIS _) body) =
  do prntDoc dt body
     prntMake dt
prnt (Recipe dt@(LPM _) body) =
  do prntDoc dt body
prnt (Recipe dt@(Website fn) body) =
  do prntDoc dt body
     outh2 <- openFile ("Website/" ++ fn ++ ".css") WriteMode
     hPutStrLn outh2 $ render (makeCSS body)
     hClose outh2

-- | Helper for writing the documents (TeX / HTML) to file
prntDoc :: DocType -> Document -> IO ()
prntDoc dt body = case dt of
  (SRS fn)     -> prntDoc' dt fn TeX body
  (MG fn)      -> prntDoc' dt fn TeX body
  (MIS fn)     -> prntDoc' dt fn TeX body
  (LPM fn)     -> prntDoc' dt fn TeX body
  (Website fn) -> prntDoc' dt fn HTML body
  where prntDoc' dt' fn format body' = do
          createDirectoryIfMissing False $ show dt'
          outh <- openFile (show dt' ++ "/" ++ fn ++ getExt format) WriteMode
          hPutStrLn outh $ render $ (writeDoc format dt' body')
          hClose outh
          where getExt TeX  = ".tex"
                getExt HTML = ".html"
                getExt _    = error "we can only write TeX/HTML (for now)"

-- | Helper for writing the Makefile(s)
prntMake :: DocType -> IO ()
prntMake dt =
  do outh <- openFile (show dt ++ "/Makefile") WriteMode
     hPutStrLn outh $ render $ genMake [dt]
     hClose outh

-- | Renders the documents
writeDoc :: Format -> DocType -> Document -> Doc
writeDoc TeX  = genTeX
writeDoc HTML = genHTML
writeDoc _    = error "we can only write TeX/HTML (for now)"

-- | Calls the code generator using the 'ModuleChunk's
genCode :: NamedIdea c => c -> [ModuleChunk] -> IO ()
genCode cc mcs = prntCode cc (filter generated mcs)

-- | Generate code for all supported languages (will add language selection later)
prntCode :: NamedIdea c => c -> [ModuleChunk] -> IO ()
prntCode cc mcs = 
  let absCode = toCode cc mcs
      code l  = makeCode l
        (Options Nothing Nothing Nothing (Just "Code"))
        (map (\mc -> makeClassNameValid $ (modcc mc) ^. id) mcs)
        absCode
      writeCode c lang = do
        let newDir = c ++ "/" ++ lang
        createDirectoryIfMissing False newDir
        setCurrentDirectory newDir
        createCodeFiles $ code lang

  in  do
      workingDir <- getCurrentDirectory
      let writeCode' = writeCode workingDir
      writeCode' cppLabel
 --     writeCode' javaLabel
 --     writeCode' luaLabel
 --     writeCode' cSharpLabel
 --     writeCode' goolLabel
 --     writeCode' objectiveCLabel
 --     writeCode' pythonLabel
      setCurrentDirectory workingDir
