debug = require('debug')('rupert:servers')

module.exports = (config, app)->
    tls = config.find('tls', 'TLS', false)
    if tls
        debug("Configuring TLS")
        config.tls = {} if config.tls is true
        require('./51_secure')(config, app)
        .then (_)->
            app.servers = _
            app.server = _.https
            app.url = process.env.URL = config.find('url', 'URL', config.HTTPS_URL)
            app
    else
        debug("No TLS")
        require('./52_unsecure')(config, app)
        .then (_)->
            app.servers = _
            app.server = _.http
            app.url = process.env.URL = config.find('url', 'URL', config.HTTP_URL)
            app