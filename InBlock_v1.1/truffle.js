// Allows us to use ES6 in our migrations and tests.
require('babel-register')

/*
module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    }
  }
}
*/

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
    networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' ,// Match any network id
	  gasPrice: 4000000000
    }
  },

    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};