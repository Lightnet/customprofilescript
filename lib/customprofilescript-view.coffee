{View} = require 'atom'

CustomProfileScriptConsoleView = require './customprofilescript-console-view'

module.exports =
class CustomprofilescriptView


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

    @customprofilescriptconsoleview = new CustomProfileScriptConsoleView()
    #atom.workspaceView.appendToBottom(@customprofilescriptconsoleview)


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
