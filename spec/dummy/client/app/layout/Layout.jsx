import React, { PropTypes } from 'react';
import { Link } from 'react-router';

export default class Layout extends React.Component {

  static propTypes = {
    children: PropTypes.object.isRequired,
  }

  render() {
    return (
      <section>
        <header>
          <ul>
            <li>
              <Link to={`${window.location.pathname}`}>Hello World Router</Link>
            </li>
            <li>
              <Link to={`${window.location.pathname}/react-router-redirect`}>Hello World Router Redirect</Link>
            </li>
          </ul>
        </header>
        {this.props.children}
      </section>
    );
  }
}