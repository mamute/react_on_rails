import React from 'react';

export default class HelloWorldWithRouterRedirect extends React.Component {

  static checkAuth(nextState, replaceState) {
    const notAuthorized = true;
    if (notAuthorized) {
      replaceState({ redirectFrom: nextState.location.pathname }, '/server_side_redux_app_with_router');
    }
  }

  render() {
    return (
      <div>Nope.</div>
    );
  }

}