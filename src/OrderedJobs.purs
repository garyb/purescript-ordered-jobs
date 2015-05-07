module OrderedJobs where

import Control.Alt ((<|>))
import Control.Apply ((*>))
import Data.Array (nub, catMaybes, length)
import Data.Either (Either(..))
import Data.Graph (Graph(..), Edge(..), SCC(..), scc)
import Data.Maybe (Maybe())
import Data.Traversable (traverse)
import Text.Parsing.StringParser (Parser(), runParser)
import Text.Parsing.StringParser.Combinators (many1, sepBy1, optionMaybe)
import Text.Parsing.StringParser.String (string, anyChar)

type Entry = { job :: String, edge :: Maybe (Edge String) }

getSequence :: String -> Either String [String]
getSequence "" = Right []
getSequence s = case runParser parseInput s of
  Left err -> Left (show err)
  Right entries -> checkSCC `traverse` scc (makeGraph entries)
  where
  checkSCC :: SCC String -> Either String String
  checkSCC (AcyclicSCC job) = Right job
  checkSCC (CyclicSCC grp) | length grp == 1 = Left "Jobs cannot depend upon themselves"
                           | otherwise = Left "Jobs cannot have circular dependencies"

parseInput :: Parser [Entry]
parseInput = sepBy1 entry (many1 separator)
  where

  entry :: Parser Entry
  entry = do
    job <- anyChar
    string " =>"
    dependency <- optionMaybe $ whitespace *> anyChar
    return $ { job: job, edge: flip Edge job <$> dependency }

  whitespace :: Parser Unit
  whitespace = many1 (string " ") *> pure unit

  separator :: Parser Unit
  separator = whitespace
          <|> (string "\n" <|> string "\r") *> pure unit

makeGraph :: [Entry] -> Graph String String
makeGraph entries = Graph (_.job <$> entries) (catMaybes $  _.edge <$> entries)
