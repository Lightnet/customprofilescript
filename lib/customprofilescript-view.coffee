###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###
# Main code to run scripts

{View} = require 'atom'

CustomProfileScriptConsoleView = require './customprofilescript-console-view'
CustomProfileScriptAvatarView = require './customprofilescript-avatar-view'

module.exports =
class CustomprofilescriptView
  customprofilescriptConsoleView: null #Console
  customprofilescriptAvatarView: null #Avatar

  constructor: (serializeState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('customprofilescript',  'overlay', 'from-top')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Customprofilescript package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    # Register command that toggles this view
    atom.commands.add 'atom-workspace', 'customprofilescript:toggle': => @toggle()
    atom.commands.add 'atom-workspace', 'customprofilescript:togglemsg': => @togglemsg()
    #atom.commands.add 'atom-workspace', 'customprofilescript:settings': => @togglesettings()

    @customprofilescriptConsoleView = new CustomProfileScriptConsoleView()
    atom.workspaceView.appendToBottom(@customprofilescriptConsoleView)

    @customprofilescriptAvatarView = new CustomProfileScriptAvatarView()
    atom.workspaceView.appendToBottom(@customprofilescriptAvatarView)
    #console.log this

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  # Toggle the visibility of this view
  toggle: ->
    console.log 'CustomprofilescriptView was toggled!'

    if @element.parentElement?
      @element.remove()
    else
      atom.workspaceView.append(@element)

  togglemsg: ->
    atom.emit 'achievement:unlock', msg: 'Homestar Runner'
    console.log atom

  togglesettings: ->
    #console.log atom
    atom.workspaceView.trigger 'customprofilescript:open'
