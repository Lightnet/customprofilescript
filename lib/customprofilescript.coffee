
#Main file starter to lanuch the application

CustomProfileScriptSettingsView = null
customprofilescriptSettingsView = null

configUri = 'atom://customprofilescript'

CustomprofilescriptView = require './customprofilescript-view'
CustomProfileScriptConsoleView = require './customprofilescript-console-view'
CustomProfileScriptToolbarView = require './customprofilescript-toolbar-view'

createSettingView = (params)->
  CustomProfileScriptSettingsView ?= require './customprofilescript-settings-view'
  customprofilescriptSettingsView = new CustomProfileScriptSettingsView(params)

openPanel = (panelName) ->
  atom.workspaceView.open(configUri)
  customprofilescriptSettingsView.showPanel(panelName)

deserializer =
  name: 'CustomProfileScriptSettingsView'
  version: 2
  deserialize: (state) ->
    console.log "state"
    console.log state
    createSettingsView(state) if state.constructor is Object
atom.deserializers.add(deserializer)

module.exports =
  customprofilescriptView: null
  customprofilescriptConsoleView: null
  customprofilescriptToolbarView: null

  activate: (state) ->
    @customprofilescriptView = new CustomprofilescriptView(state.customprofilescriptViewState)
    @customprofilescriptToolbarView = new CustomProfileScriptToolbarView()
    atom.workspaceView.appendToTop(@customprofilescriptToolbarView)
    console.log atom.workspaceView

    atom.workspace.registerOpener (uri) ->
      createSettingsView({uri}) if uri is configUri

    atom.workspaceView.command 'settings-view:open', ->
      openPanel('Settings')

    

    #console.log @customprofilescriptView
    #@customprofilescriptConsoleView = new CustomProfileScriptConsoleView
    #console.log @customprofilescriptConsoleView #view class

  deactivate: ->
    @customprofilescriptView.destroy()
    #@customprofilescriptConsoleView.close() #view class

  serialize: ->
    customprofilescriptViewState: @customprofilescriptView.serialize()
    #customprofilescriptConsoleViewState: customprofilescriptConsoleView.serialize() #view class #not does not work
