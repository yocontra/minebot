mineflayer = require 'mineflayer'

inventory = (c, opt) ->
  addItem = (slot, item) ->
    c.entity.inventory ?= []
    if item.id is -1
      c.entity.inventory[slot] = null
    else
      c.entity.inventory[slot] =
        id: item.id
        count: item.itemCount
        damage: item.itemDamage

  c.client.on 0x67, (packet) ->
    return unless packet.windowId is 0
    addItem packet.slot, packet.item
    c.emit 'inventoryUpdate'

  c.client.on 0x68, (packet) ->
    return unless packet.windowId is 0
    addItem idx, item for item, idx in packet.items
    c.emit 'inventoryUpdate'

radar = (c, opt) ->
  c.radar ?= {}
  updateRadar = (type, entity) ->
    return unless entity.type is 'player'

    if type is 'remove'
      delete c.radar[entity.username]
      c.emit 'radarRemove', entity
    else
      c.radar[entity.username] = Math.floor c.entity.position.distanceTo entity.position
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
    inventory client, opt
    return client