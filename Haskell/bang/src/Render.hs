-- módulo responsável por renderizar a parte gráfica
-- cria imagens para a visualização dos eventos na tela
module Render where

import           GameModel
import           GameState
import           Graphics.Gloss
import           ObstaclesModel
import           PokemonModel

render
  :: Picture
  -> Picture
  -> Picture
  -> Picture
  -> Picture
  -> Picture
  -> Picture
  -> BANG
  -> Picture

-- map (func arg1 arg2) your_list


-- renderiza as imagens referentes ao jogo em estado de jogo
render image_bulbasaur image_charmander image_pokeball foreground image_belossom image_slowpoke image_stone game@Game { gameState = Playing }
  = frame
 where
  frame = pictures
    (  [positionedForegorund foreground]
    ++ map (makeObstacleBelossom image_belossom) (belossoms game)
    ++ map (makeObstacleSlowPoke image_slowpoke) (slowpokes game)
    ++ map (makeObstacleStone image_stone)       (stones game)
    ++ [makeBulbasaur (bulbasaur game) image_bulbasaur]
    ++ [makeCharmander (charmander game) image_charmander]
    ++ [makePokeBall (onShoot (bulbasaur game)) image_pokeball]
    ++ [makePokeBall (onShoot (charmander game)) image_pokeball]
    )

-- renderiza as imagens referentes ao jogo em estado de menu
render _ _ _ _ _ _ _ game@Game { gameState = Menu } = pictures
  [ makeText black "BANG!"                0.6 0.6 (-100) 0
  , makeText black "PRESS ENTER TO START" 0.3 0.3 (-215) 100
  , makeText black "PRESS ESC TO QUIT"    0.3 0.3 (-190) (-100)
  ]

-- renderiza as imagens referentes ao jogo em estado de end 
render _ _ _ _ _ _ _ game@Game { gameState = End } = pictures
  [ makeText black "WIN!"        0.6 0.6 (-100) 0
  , makeText black (winner game) 0.3 0.3 (-100) (-100)
  ]

-- constroí a imagem responsável por mostrar o texto na tela
makeText :: Color -> String -> Float -> Float -> Float -> Float -> Picture
makeText textColor text x y x' y' =
  translate x' y' $ scale x y $ color textColor $ Text text

positionedForegorund :: Picture -> Picture
positionedForegorund = translate 0.0 0.0

makeBulbasaur :: Pokemon -> Picture -> Picture
makeBulbasaur _bulbasaur = translate x y where (x, y) = location _bulbasaur

makeCharmander :: Pokemon -> Picture -> Picture
makeCharmander _charmander = translate x y where (x, y) = location _charmander

makePokeBall :: Pokeball -> Picture -> Picture
makePokeBall _pokeball = translate x y
  where (x, y) = locationPokeball _pokeball

makeObstacleBelossom :: Picture -> Belossom -> Picture
makeObstacleBelossom _image _belossom = translate x y _image
  where (x, y) = belossomLocation _belossom

makeObstacleSlowPoke :: Picture -> SlowPoke -> Picture
makeObstacleSlowPoke _image _slowpoke = translate x y _image
  where (x, y) = slowPokeLocation _slowpoke

makeObstacleStone :: Picture -> Stone -> Picture
makeObstacleStone _image _stone = translate x y _image
  where (x, y) = stoneLocation _stone
