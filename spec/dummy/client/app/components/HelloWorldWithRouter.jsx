import React, { PropTypes } from 'react';

export default class HelloWorldWithRouter extends React.Component {

  static propTypes = {
    location: PropTypes.shape({
      state: PropTypes.object,
    }).isRequired
  }

  _renderNotification() {
    const locationState = this.props.location.state;
    if (!locationState || !locationState.redirectFrom) return null;

    return (
      <div className="notification bg-success">
        You've been redirected from <strong>{locationState.redirectFrom}</strong>
      </div>
    );
  }

  render() {
    return (
      <div className="container">
        {::this._renderNotification()}
        <h1>React Router is working!</h1>
        <p>
          Woohoo, we can use <code>react-router</code> here!
        </p>
      </div>
    );
  }
}