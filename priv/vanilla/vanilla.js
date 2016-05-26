window.WebSocketHandler = (function(){
  var websocket;
  var messages = 0;

  var statusElt = document.getElementById('status');
  var serverTimeElt = document.getElementById('serverTime');
  var clientMessageElt = document.getElementById('clientMessage');
  var serverMessageElt = document.getElementById('serverMessage');
  var sendButtonElt = document.getElementById('sendButton');

  sendButtonElt.onclick = sendClientMessage;

  function sendClientMessage() {
    var value = clientMessageElt.value;
    message = { 'message': value };
    websocket.send(JSON.stringify(message));
  };

  function disconnect() {
    websocket.close();
  };

  function onOpen(event) {
    statusElt.innerHTML = '<span style="color: #00E;">CONNECTED</span>';
  };

  function onClose(event) {
    statusElt.innerHTML = '<span style="color: #E00;">DISCONNECTED</span>';
  };

  function onMessage(event) {
    var message = JSON.parse(event.data);
    if (message.time != undefined) {
      serverTimeElt.innerText = message.time;
    }
    if (message.ok != undefined) {
      serverMessageElt.innerText = message.ok;
    }
  };

  return {
    init: function() {
      statusElt.innerHTML = '<span style="color: #E00;">DISCONNECTED</span>';
      websocket = new WebSocket('ws://localhost:8080/ws');
      websocket.onopen = onOpen;
      websocket.onclose = onClose;
      websocket.onmessage = onMessage;
    },
  }
})();
