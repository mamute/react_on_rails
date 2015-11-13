// This is loaded by execJs and Rails to generate the HTML used for server rendering.
// Compare this file to ./ClientApp.jsx
// This module should export one default method that take props and returns the react component to
// render.

import React from 'react';
import { combineReducers } from 'redux';
import { applyMiddleware } from 'redux';
import { createStore } from 'redux';
import { Provider } from 'react-redux';
import middleware from 'redux-thunk';
import { match, RoutingContext } from 'react-router';

// Uses the index
import reducers from '../reducers/reducersIndex';
import routes from '../routes/routes';

const ReduxRouterApp = (props, location) => {
  const combinedReducer = combineReducers(reducers);

  // This is where we'll put in the middleware for the async function. Placeholder.
  // store will have helloWorldData as a top level property
  const store = applyMiddleware(middleware)(createStore)(combinedReducer, props);

  let routeError
  let routeRedirect;
  let routeProps;

  match({ routes, location }, (_routeError, _routeRedirect, _routeProps) => {
    routeError = _routeError;
    routeRedirect = _routeRedirect;
    routeProps = _routeProps;
  });

  if (routeError) {
    // TODO: We should handle errors from router inside `react_on_rails` gem
    return { routeError };
  }

  if (routeRedirect) {
    // TODO: We should handle redirects from router inside `react_on_rails` gem
    return { routeRedirect };
  }

  // Provider uses the this.props.children, so we're not typical React syntax.
  // This allows redux to add additional props to the HelloWorldContainer.
  return (
    <Provider store={store}>
      <RoutingContext {...routeProps} />
    </Provider>
  );
};

/*
 *  Export a function that takes the props and returns a ReactComponent.
 *  Ensure that option generator_function is set to true when invoking the helper, or as the default.
 */

export default ReduxRouterApp;
