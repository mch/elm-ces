import StartApp exposing (start)
import Time exposing (Time, fps, second)
import Signal
import Mouse
import Html exposing (Html, text)
import Task exposing (Task)
import Effects exposing (Effects, Never, none)

-- References
-- http://www.chris-granger.com/2012/12/11/anatomy-of-a-knockout/
-- http://www.chris-granger.com/2013/01/24/the-ide-as-data/

  
-- Entities might need to have components added to them at run time,
-- e.g. an explosiong effect. Perhaps that kind of thing could be
-- separated out into a list of "effects," where effects don't
-- interact via systems, other than to be added or removed from
-- entities.
--
-- Rather than a list of compontents, it might be better to build
-- entities using extensible records. This would allow type safety of
-- systems, but systems would have to return relationships between
-- entities which would have to be resolved at a higher level.
--
-- Another option is to keep component data together in the model,
-- i.e. each component has a separate List of ComponentData within the
-- model, and systems are applied to specific lists of component
-- data. It probably shouldn't be restricted to lists, but rather some
-- component specific data structure that allows for whatever
-- performance characteristics are required for efficiency,
-- e.g. collidable things need to be stored in a quad tree. In that
-- case, there needs to be a mapping between entitiy IDs and component
-- data, perhaps a Dict. This might be best, because Systems will
-- probably be applied to specific components, not arbitrary lists of
-- entities.
type alias Entity
  = { id : Int
    , components : List Component
    }


-- Types of operations
-- * Initial entity creation, including all initially required
--   component data
-- * Entity drawing and other operations with are specific to the
--   entity, but may require all component data for an entity
-- * Systems, which operate on multiple entities and depend on a
--   subset of component data. May result in creation of new entities,
--   removal of old entities, updates to component data for each
--   entity, and other "events," which would need to be captured as
--   data and returned to a higher level to resolve.
-- * ...? 


type alias PhysicsData
  = { position : ( Float, Float )
    , velocity : ( Float, Float )
    }
  
  
type alias BoundingCircleData
  = { radius : Float }


-- Adding a component means extending this type. Maybe that's not so
-- bad for a game, because Systems act on specific
-- components. Components and systems could be defined in modules,
type Component
  = Physics PhysicsData
  | BoundingCircle BoundingCircleData


type alias Model
  = { nextId : Int
    , entities : List Entity
    }


type alias InputData
  = { dt : Time
    , mx : Float
    , my : Float
    }
  
  
init = (Model 0 [], none)


update : InputData -> Model -> (Model, Effects InputData)
update input model =
  (model, none)


view : Signal.Address InputData -> Model -> Html
view address model =
  text "Hello"


ticker = Time.fps 30

         
inputs = Signal.map3 InputData ticker (Signal.map toFloat Mouse.x) (Signal.map toFloat Mouse.y)


app = start { init = init, update = update, view = view, inputs = [inputs] }


main = app.html


port runner : Signal (Task Never ())
port runner = app.tasks
