Meteor.methods
  keepalive: (params) ->
    userInterval = config?.keepalive?.interval ? 60
    userTimeout = config?.keepalive?.timeout ? 10
    return false unless @userId
    Meteor.keepalive ?= {}
    Meteor.clearTimeout Meteor.keepalive[@userId] if Meteor.keepalive[@userId]
    (setOnline = (online) =>
      user = Meteor.users.findOne(@userId)
      unless user.profile.online is online
        Meteor.users.update user._id, $set: {'profile.online': online}
    )(true)
    Meteor.keepalive[@userId] = Meteor.setTimeout (=>
      delete Meteor.keepalive[@userId]
      setOnline(false)
    ), (userInterval + userTimeout) * 1000
    return true
