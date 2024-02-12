const Hapi = require('@hapi/hapi')
const routes = require('./routes')
require('dotenv').config()

const init = async () => {
  const server = Hapi.server({
    host: process.env.HOST || "0.0.0.0",
    port: parseInt(process.env.PORT) || 5000,
    routes: {
      cors: {
        origin: ['*'],
      },
    },
  })

  server.route(routes)

  await server.start()
  console.log(`Server running on ${server.info.uri}`)
}

init().catch((error) => {
  console.error(`Error starting the server : ${error}`)
})
