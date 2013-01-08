minebot = require '../'

client = minebot.createClient
  #host: "mc.diamcraft.com"
  host: "mc.toxicterritory.org"
  port: 25565
  username: process.env.MC_USER
  email: process.env.MC_EMAIL
  password: process.env.MC_PASS

client.on 'error', (err) -> console.error err
client.on 'connect', -> console.log "Connected"
client.on 'login', -> console.log "Logged in"
client.on 'kicked', (reason) -> console.log "Kicked for #{reason}"
client.on 'spawn', -> console.log "Spawned"
client.on 'death', -> console.log "Died"
client.on 'end', -> process.exit()

client.on 'health', ->
  console.log "I have #{client.food} health and #{client.food} food"

client.on 'chat', (user, msg, raw) ->
  console.log "[Chat] #{user}: #{msg}"

client.on 'nonSpokenChat', (msg, raw) ->
  console.log "[Chat] #{raw}"

client.on 'radarChange', ->
  console.log client.radar
  

module.exports = client