mineflayer = require 'mineflayer'

radar = (c, opt) ->
  c.radar ?= {}

  c.nearestPlayer = -> c.nearest (v) -> v.type is 'player'
  c.nearestPlayerWithinRange = ->
    p = c.nearestPlayer()
    (if p.withinRange then p else null)

  c.nearestMobWithinRange = ->
    p = c.nearestMob()
    return (if p.withinRange then p else null)

  c.nearestMob = -> c.nearest (v) -> v.type is 'mob'

  c.nearestObjectWithinRange = ->
    p = c.nearestObject()
    return (if p.withinRange then p else null)

  c.nearestObject = -> c.nearest (v) -> v.type is 'object'

  c.nearestWithinRange = (fn) ->
    p = c.nearest fn
    return (if p.withinRange then p else null)

  c.nearest = (fn) ->
    fn ?= -> true
    radar = (v for k,v of c.radar when fn(v))
    [nearest] = radar.sort (a,b) -> a.distance-b.distance
    return nearest

  updateRadar = (type, entity) ->
    return if entity.id is c.entity.id

    if type is 'remove'
      delete c.radar[entity.id]
      c.emit 'radarRemove', entity
    else
      entity.distance = c.entity.position.distanceTo entity.position
      entity.withinRange = entity.distance <= 6
      c.radar[entity.id] = entity
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