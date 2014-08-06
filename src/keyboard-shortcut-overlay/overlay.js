define([
  'react',
  'jsx!./component'
], function(
  React,
  OverlayComponent
){

  function Overlay(domNode) {
    this._domNode = domNode;
  }

  Overlay.prototype = {

    _component: null,

    render: function() {
      this._component = React.renderComponent(OverlayComponent(), this._domNode);
    },

    show: function() {
      this._component.show();
    },

    hide: function() {
      this._component.hide();
    }

  };

  return Overlay;
});
