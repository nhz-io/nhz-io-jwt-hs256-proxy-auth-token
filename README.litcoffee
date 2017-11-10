# CouchDB ProxyAuth JWT HS256 Token generator

[![Travis Build][travis]](https://travis-ci.org/nhz-io/nhz-io-jwt-hs256-proxy-auth-token)
[![NPM Version][npm]](https://www.npmjs.com/package/@nhz.io/jwt-hs256-proxy-auth-token)

> Generate JWT tokens with payload for CouchDB ProxyAuth (with expiration)

## Install

```bash
npm i @nhz.io/jwt-hs256-proxy-auth-token
```

## Usage

```js
const jwt = require('@nhz.io/jwt-hs256-proxy-auth-token')

const DURATION = 120 // seconds. Default.

token = jwt('secret', 'user', ['role1', 'role2'], DURATION)
```

## Verified token example

> This is what the token will look like after successful verification with [jsonwebtoken][]

```json
{
  "exp": 1510356100,
  "iat": 1510356220,
  "data": {
    "user": "username",
    "roles": ["role1", "role2"]
  }
}
```

### Imports

    jwt = require 'jsonwebtoken'

### Generate token

> Curry to allow reuse

    generate = (secret) -> (user) -> (roles, duration) ->

> Sanity

      throw Error 'Invalid secret' unless secret and typeof secret is 'string'

      throw Error 'Invalid user' unless user and typeof user is 'string'

> Roles should be array of strings

      roles ?= []

      throw Error 'Invalid roles' unless Array.isArray roles

      throw Error 'Invalid roles' if (roles.filter (r) -> not r or typeof r isnt 'string').length

> Default duration is 120 seconds

      duration ?= 120

> Max duration is one hour

      throw Error 'Invalid duration' if (isNaN duration) or duration > 3600

> Sign the token

      jwt.sign { data: { user, roles }, exp: Math.floor Date.now() / 1000 + duration }, secret

### API Wrapper

> Wrapper to allow calling both curried and full arguments

    jwtHS256ProxyAuthToken = (secret, user, roles, duration) ->

> Start curried

      token = generate secret

> Complete invocation or return curried generator

      token = if user then token user else token

      if roles then token roles, duration else token

### Exports

    module.exports = jwtHS256ProxyAuthToken

## Test

    assert = require 'assert'

> Test curry

    assert.ok typeof (jwtHS256ProxyAuthToken 'secret') is 'function'

    assert.ok typeof (jwtHS256ProxyAuthToken 'secret')('user') is 'function'

    assert.ok typeof (jwtHS256ProxyAuthToken 'secret')('user')([]) is 'string'

> Test validation

    jwtHS256ProxyAuthToken()

    assert.throws (-> jwtHS256ProxyAuthToken()()()), /Invalid secret/

    assert.throws (-> jwtHS256ProxyAuthToken(1)()()), /Invalid secret/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')()()), /Invalid user/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')(1)()), /Invalid user/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')('user')('foo')), /Invalid roles/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')('user')([1])), /Invalid roles/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')('user')([undefined])), /Invalid roles/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')('user')([''])), /Invalid roles/

    assert.throws (-> jwtHS256ProxyAuthToken('secret')('user')([], 3601)), /Invalid duration/

> Test token

    token = jwtHS256ProxyAuthToken 'secret', 'foo', ['users', 'foos']

    assert.ok jwt.verify token, 'secret'

> Test bad secret

    assert.throws (-> jwt.verify token, 'bad-secret'), /invalid signature/

> Test payload

    assert.deepEqual { user: 'foo', roles: ['users', 'foos'] }, (jwt.verify token, 'secret').data

> Test expiration

    token = jwtHS256ProxyAuthToken 'secret', 'foo', ['users', 'foos'], -1

    assert.throws (-> jwt.verify token, 'secret'), /jwt expired/

    console.log 'pass'

## Version 1.0.0

## License [MIT](LICENSE)

[jsonwebtoken]: https://github.com/auth0/node-jsonwebtoken
[travis]: https://img.shields.io/travis/nhz-io/nhz-io-jwt-hs256-proxy-auth-token.svg?style=flat
[npm]: https://img.shields.io/npm/v/@nhz.io/jwt-hs256-proxy-auth-token.svg?style=flat
