-- | Main entry point for the example app.
module Main 
  ( main
  ) where

import Control.Monad.Aff (Aff, launchAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Ref (newRef)
import Example.Component.Router as R
import Example.Component.Router.Query (Query(..))
import Example.Control.Monad (PushType(..), runExample)
import Example.EffectType (EffectType)
import Example.Server.ServerAPI (APIToken(..), secretKey)
import FRP.Event (create, subscribe)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Prelude (Unit, Void, bind, discard, pure, unit, ($), (<<<))

-- | This is where everything ties toghether.
-- | We first make sure the prerequisites for running our app exist:
-- |
-- | `body`, the element that will contain our app
-- | `environment` as our application's non-mutable environment
-- | `state`, our application's state, as a `Ref Int`
-- | `event`, our `behavior` which allows us to push events back from our `run`
-- | `token`, as our API's secret / authentication token
-- | 
-- | we then transform (hoist) the router component from our `Example` monad
-- | to a regular `Aff`-based component that goes into `runUI`
-- |
-- | finally, we `subscribe` to our event using `handler`
main :: Eff (HA.HalogenEffects EffectType) Unit
main = HA.runHalogenAff do
  body  <- HA.awaitBody

  let environment = 42
  state <- liftEff <<< newRef $ 0
  event <- liftEff create
  let token = APIToken secretKey

  let router' = H.hoist (runExample environment state event.push token) R.component
  driver <- runUI router' unit body
  liftEff $ subscribe event.event (handler driver)

  where

-- | Using the component's `driver`, whenever we get a `PushType` value
-- | from our runExample, we trigger an `action` in our `driver.query`.
  handler :: H.HalogenIO Query Void (Aff (HA.HalogenEffects EffectType))
          -> PushType
          -> Eff (HA.HalogenEffects EffectType) Unit
  handler driver pt = do
    case pt of
      PushRoute route -> do
        _ <- launchAff $ driver.query <<< H.action <<< Goto $ route
        pure unit
      PushShowDialog opts -> do
        _ <- launchAff $ driver.query <<< H.action <<< ShowDialog $ opts         
        pure unit
    pure unit