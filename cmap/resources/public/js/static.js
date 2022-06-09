const coords = [2.295, 48.8737]

const style =
      React.createElement(
          rlayers.RStyle.RStyle,
          { /* attributes is a mandatory prm even when empty */ },
          React.createElement(
              rlayers.RStyle.RIcon,
              { src: './img/location.svg', anchor: [0.5, 0.8] })
      )

const feature =
      React.createElement(
          rlayers.RFeature,
          {
              geometry: new ol.geom.Point(ol.proj.fromLonLat(coords)),
              onClick: (e) => {
                  // TODO call this function from dev console
                  console.log('RFeature onClick');
                  e.map.getView().fit(
                      e.target.getGeometry().getExtent(),
                      {duration: 250, maxZoom: 15})
              }
          },
          React.createElement(
              rlayers.ROverlay, { className: 'example-overlay' },
              /* "some text", */
              React.createElement(
                  "div",
                  { /* attributes is a mandatory prm even when empty */ },
                  "Click the PIN to zoom"
              )
          )
      )

const el = React.createElement(
    rlayers.RMap,
    {
        className: 'map',
        initial: { center: ol.proj.fromLonLat([2.364, 48.82]), zoom: 11 }
    },
    React.createElement(
        rlayers.ROSM
        /* attributes must NOT be specified */
    ),
    React.createElement(
        rlayers.RLayerVector, { zIndex: 10 }, style, feature
    )
)

const root = ReactDOM.createRoot(document.getElementById('app'))
root.render(React.createElement(() => { return el }));
