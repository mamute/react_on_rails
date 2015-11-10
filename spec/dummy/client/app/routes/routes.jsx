import React from 'react';
import { Route } from 'react-router';

import Layout from '../layout/Layout';
import HelloWorldWithRouter from '../components/HelloWorldWithRouter';
import HelloWorldWithRouterRedirect from '../components/HelloWorldWithRouterRedirect';

export default (
  <Route component={Layout}>
    <Route
      path="/server_side_redux_app_with_router"
      component={HelloWorldWithRouter}
    />
    <Route
      path="/server_side_redux_app_with_router/react-router-redirect"
      component={HelloWorldWithRouterRedirect}
      onEnter={HelloWorldWithRouterRedirect.checkAuth}
    />
  </Route>
);