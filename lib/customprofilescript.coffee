CustomprofilescriptView = require './customprofilescript-view'

module.exports =
  customprofilescriptView: null

  activate: (state) ->
    @customprofilescriptView = new CustomprofilescriptView(state.customprofilescriptViewState)

  deactivate: ->
    @customprofilescriptView.destroy()

  serialize: ->
    customprofilescriptViewState: @customprofilescriptView.serialize()
