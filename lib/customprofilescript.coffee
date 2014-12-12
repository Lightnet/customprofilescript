###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###

{View} = require 'atom'
path = require 'path'

configUri = 'customprofilescript://my-config-view'
CustomProfileScriptConfigView = null
customprofilescriptConfigView = null

#Main file starter to lanuch the application
CustomprofilescriptView = require './customprofilescript-view' #main entry
CustomProfileScriptToolbarView = require './customprofilescript-toolbar-view'
CustomProfileScriptConsoleView = require './customprofilescript-console-view'
#CustomProfileScriptSettingsView = require './customprofilescript-settings-view'

createMyView = (params) ->
  CustomProfileScriptConfigView ?= require './customprofilescript-config-view'
  customprofilescriptConfigView = new CustomProfileScriptConfigView(params)

module.exports =
  configDefaults:
    avatarviewposx: 10
    avatarviewposy: 10


  customprofilescriptView: null
  customprofilescriptConsoleView: null
  customprofilescriptToolbarView: null


  activate: (state) ->
    @customprofilescriptView = new CustomprofilescriptView(state.customprofilescriptViewState)
    @customprofilescriptToolbarView = new CustomProfileScriptToolbarView()
    atom.workspaceView.appendToTop(@customprofilescriptToolbarView)
    #console.log "configUri"
    #console.log configUri

    atom.workspace.addOpener (uri) ->
      createMyView({uri}) if uri is configUri

    #binding command
    atom.commands.add 'atom-workspace', 'customprofilescript:show-my-config-view', ->
      atom.workspace.open configUri

    #atom.config.set('customprofilescript.avatarviewposx', '12')
    #atom.config.set('customprofilescript.someSetting', '12')
    #console.log atom.config.get('customprofilescript.someSetting') # -> 12
    #console.log atom.config.get('customprofilescript.avatarviewposx') # -> 12

  deactivate: ->
    @customprofilescriptView.destroy()
    #@customprofilescriptConsoleView.close() #view class

  serialize: ->
    customprofilescriptViewState: @customprofilescriptView.serialize()
    #customprofilescriptConsoleViewState: customprofilescriptConsoleView.serialize() #view class #not does not work
