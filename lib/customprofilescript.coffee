



#Main file starter to lanuch the application


CustomprofilescriptView = require './customprofilescript-view'
CustomProfileScriptConsoleView = require './customprofilescript-console-view'

module.exports =
  customprofilescriptView: null
  customprofilescriptConsoleView: null

  activate: (state) ->
    @customprofilescriptView = new CustomprofilescriptView(state.customprofilescriptViewState)
    console.log @customprofilescriptView
    #@customprofilescriptConsoleView = new CustomProfileScriptConsoleView
    #console.log @customprofilescriptConsoleView #view class

  deactivate: ->
    @customprofilescriptView.destroy()
    #@customprofilescriptConsoleView.close() #view class

  serialize: ->
    customprofilescriptViewState: @customprofilescriptView.serialize()
    #customprofilescriptConsoleViewState: customprofilescriptConsoleView.serialize() #view class #not does not work
