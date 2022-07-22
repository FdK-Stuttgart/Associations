const coords = [2.295, 48.8737]

const style_with_icon =
      React.createElement(
          rlayers.RStyle.RStyle, {
              /* attributes are mandatory even when empty */
          },
          React.createElement(
              rlayers.RStyle.RIcon, {
                  src: './img/location.svg', anchor: [0.5, 0.8]
              })
      )

const feature_with_overlay =
      React.createElement(
          rlayers.RFeature,
          {
              geometry: new ol.geom.Point(ol.proj.fromLonLat(coords)),
              onClick: (e) => {
                  // TODO call this function from dev console
                  console.log('RFeature onClick');
                  e.map.getView().fit(
                      e.target.getGeometry().getExtent(),
                      { duration: 250, maxZoom: 15 })
              }
          },
          React.createElement(
              rlayers.ROverlay, {
                  className: 'example-overlay'
              },
              /* "some text", */
              React.createElement(
                  "div", { /* attributes are mandatory even when empty */ },
                  "Click the PIN to zoom"
              )
          )
      )
const popup =
      React.createElement(
          rlayers.RPopup, {
              trigger: "click", className: 'example-overlay'
         },
          /* "some text", */
          React.createElement(
              "div", { /* attributes are mandatory even when empty */ },
              "Popup on click"
          )
      )

const feature_with_popup =
      React.createElement(
          rlayers.RFeature, {
              geometry: new ol.geom.Point(ol.proj.fromLonLat(coords))
          },
          popup
      )

const osm =
      React.createElement(rlayers.ROSM /* attributes must NOT be specified */)


// console.log('p.props.trigger:', p.props.trigger)
// const o = osm
// const p = popup
// const fp = feature_with_popup

const el = React.createElement(
    rlayers.RMap, {
        className: 'map',
        initial: { center: ol.proj.fromLonLat([2.364, 48.82]), zoom: 11 }
    },
    osm,
    React.createElement(
        rlayers.RLayerVector, { zIndex: 10 },
        style_with_icon,
        // feature_with_overlay
        feature_with_popup
    )
)

const root = ReactDOM.createRoot(document.getElementById('app'))
root.render(React.createElement(() => { return el }));
