import React from 'react';

export default class HelloWorldWithRouterRedirect extends React.Component {

  static checkAuth(nextState, replaceState) {
    const notAuthorized = true;

    if (notAuthorized) {
      replaceState({ redirectFrom: nextState.location.pathname }, `${nextState.location.pathname.replace("/react-router-redirect", "")}`);
    }
  }

  render() {
    return (
      <div>Nope.</div>
    );
  }

}