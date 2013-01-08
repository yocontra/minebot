mineflayer = require 'mineflayer'

radar = (c, opt) ->
  c.radar ?= {}
  updateRadar = (type, entity) ->
    return unless entity.type is 'player'

    if type is 'remove'
      delete c.radar[entity.username]
      c.emit 'radarRemove', entity
    else
      c.radar[entity.username] = c.entity.position.distanceTo entity.position
      c.emit 'radarMove', entity if type is 'move'
      c.emit 'radarSpawn', entity if type is 'spawn'

    c.emit 'radarChange'

  c.on 'entitySpawn', updateRadar.bind null, 'spawn'
  c.on 'entityMoved', updateRadar.bind null, 'move'
  c.on 'entityGone', updateRadar.bind null, 'remove'

  return c


module.exports =
  createClient: (opt={}) ->
    client = mineflayer.createBot opt
    radar client, opt
    return client