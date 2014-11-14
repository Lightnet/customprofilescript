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

#Main file starter to lanuch the application
CustomprofilescriptView = require './customprofilescript-view' #main entry
CustomProfileScriptToolbarView = require './customprofilescript-toolbar-view'
CustomProfileScriptConsoleView = require './customprofilescript-console-view'

CustomProfileScriptSettingsView = require './customprofilescript-settings-view'

MyView = null
configUri = null
configUri = 'customprofilescript://my-view'

createMyView = (params) ->
  MyView ?= require './my-view'
  myView = new MyView(params)

module.exports =
  customprofilescriptView: null
  customprofilescriptConsoleView: null
  customprofilescriptToolbarView: null
  customprofilescriptSettingsView: null

  activate: (state) ->
    @customprofilescriptView = new CustomprofilescriptView(state.customprofilescriptViewState)
    @customprofilescriptToolbarView = new CustomProfileScriptToolbarView()
    atom.workspaceView.appendToTop(@customprofilescriptToolbarView)
    console.log "configUri"
    console.log configUri

    atom.workspace.addOpener (uri) ->
      createMyView({uri}) if uri is configUri

    #binding command
    atom.commands.add 'atom-workspace', 'customprofilescript:show-my-view', ->
      atom.workspace.open configUri

  deactivate: ->
    @customprofilescriptView.destroy()
    #@customprofilescriptConsoleView.close() #view class

  serialize: ->
    customprofilescriptViewState: @customprofilescriptView.serialize()
    #customprofilescriptConsoleViewState: customprofilescriptConsoleView.serialize() #view class #not does not work

  createSettingView: (params)->
    console.log "creating view"
    console.log params
    @customprofilescriptSettingsView = new CustomProfileScriptSettingsView(params)
  openPanel: (panelName) ->
    console.log atom
    atom.workspace.open configUri
