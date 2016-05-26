import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Json
import Json.Decode exposing (Decoder, keyValuePairs)
import WebSocket


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


echoServer : String
echoServer =
  "ws://127.0.0.1:8080/ws"


-- MODEL


type alias Model =
  { clientMessage : String
  , serverMessage : String
  , serverTime    : String
  }


init : (Model, Cmd Msg)
init =
  (Model "" "" "Waiting...", Cmd.none)


-- UPDATE


decoder : Decoder (List (String, String))
decoder = keyValuePairs Json.Decode.string


type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {clientMessage, serverMessage, serverTime} =
  case msg of
    Input newInput ->
      (Model newInput serverMessage serverTime, Cmd.none)

    Send ->
      let
        message = Json.encode 0 (Json.object [("message", Json.string clientMessage)])
      in
        (Model "" serverMessage serverTime, WebSocket.send echoServer message)

    NewMessage str ->
      let
        result = Debug.log "result" (Json.Decode.decodeString decoder str)
      in
        case result of
          Ok [("time", newServerTime)] ->
            (Model clientMessage serverMessage newServerTime, Cmd.none)
          Ok [("ok", newServerMessage)] ->
            (Model clientMessage newServerMessage serverTime, Cmd.none)
          Ok _ ->
            (Model clientMessage serverMessage serverTime, Cmd.none)
          Err errorMessage ->
            (Model clientMessage errorMessage serverTime, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ section []
      [ h2 []
        [ text "Server Time: "
        , text model.serverTime
        ]
      ]
    , section []
      [ h2 []
        [ text "Client Message: "
        , input [onInput Input, value model.clientMessage] []
        , button [onClick Send] [text "Send"]
        ]
      ]
    , section []
      [ h2 []
        [ text "Server Message: "
        , text model.serverMessage
        ]
      ]
    ]
