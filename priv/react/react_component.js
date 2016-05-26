ReactComponent = (function () {
  var module = {};
  var dom = React.DOM;
  var websocket;
  var component;

  var MainClass = React.createClass({

    getInitialState: function() {
      return {
        status: 'DISCONNECTED',
        time: null,
        clientMessage: '',
        serverMessage: '',
      };
    },

    render: function() {
      return dom.div(null,
        Status({ status: this.state.status }),
        ServerTime({ time: this.state.time }),
        ClientMessage({ clientMessage: this.state.clientMessage }),
        ServerMessage({ serverMessage: this.state.serverMessage })
      );
    },
  });

  var StatusClass = React.createClass({
    render: function() {
      var status = this.props.status;
      var color = (status === 'CONNECTED' ? '#00E' : '#E00' );
      return dom.section(null,
        dom.h2(null,
          'Status: ',
          dom.span({ style: { color: color }, },
            status
          )
        )
      );
    },
  });
  var Status = React.createFactory(StatusClass);


  var ServerTimeClass = React.createClass({
    render: function() {
      var time = this.props.time || 'Waiting...';
      return dom.section(null,
        dom.h2(null,
          'Server Time: ',
          dom.span(null,
            time
          )
        )
      );
    },
  });
  var ServerTime = React.createFactory(ServerTimeClass);


  var ClientMessageClass = React.createClass({
    handleChange: function(event) {
      var value = event.target.value;
      component.setState({ clientMessage: value });
    },

    handleClick: function(event) {
      message = { 'message': this.props.clientMessage };
      websocket.send(JSON.stringify(message));
    },

    render: function() {
      var message = this.props.clientMessage;;
      return dom.section(null,
        dom.h2(null,
          'Client Message: ',
          dom.input({
            type: 'text',
            placeholder: 'Enter a message',
            onChange: this.handleChange,
            value: this.props.clientMessage,
          }),
          dom.button({ onClick: this.handleClick },
            'Send'
          )
        )
      );
    },
  });
  var ClientMessage = React.createFactory(ClientMessageClass);


  var ServerMessageClass = React.createClass({
    render: function() {
      var message = this.props.serverMessage;
      return dom.section(null,
        dom.h2(null,
          'Server Message: ',
          dom.span(null,
            message
          )
        )
      );
    },
  });
  var ServerMessage = React.createFactory(ServerMessageClass);


  function onOpen(event) {
    component.setState({ status: 'CONNECTED' });
  };


  function onClose(event) {
    component.setState({ status: 'DISCONNECTED' });
  };


  function onMessage(event) {
    var message = JSON.parse(event.data);
    if (message.time != undefined) {
      component.setState({ time: message.time });
    }
    if (message.ok != undefined) {
      component.setState({ serverMessage: message.ok });
    }
  };


  module.init = function() {
    console.log('ReactComponent.init()');
    divElt = document.getElementById('main');
    component = ReactDOM.render(React.createElement(MainClass), divElt);
    websocket = new WebSocket('ws://localhost:8080/ws');
    websocket.onopen = onOpen;
    websocket.onclose = onClose;
    websocket.onmessage = onMessage;
  };

  return module;
})();
