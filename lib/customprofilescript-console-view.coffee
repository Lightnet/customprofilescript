###
 Project Name: Custom Script Builds
 Link: https://github.com/Lightnet/customscriptbuilds
 License: MIT
 Information: To run typescript for server hosting for better style format flow.
 To create a simple work flow layout. For browser game or application for html.
###

{View} = require 'atom'

module.exports =
class CustomProfileScriptConsoleView extends View

  @content: ->
    #@div class: 'overlay from-top panel', outlet: 'scriptOptionsView', => #non header
    @div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'
      @span
        class: 'heading-close icon-remove-close pull-right'
        outlet: 'closeButton'
        click: 'close'

  initialize: (@runOptions) ->
    @title.text  'Custom Profile Script'
    @setStatus 'stop'
    atom.workspaceView.command 'customprofilescript:open-console', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:close-console', =>
      @toggleScriptOptions 'hide'
    atom.workspaceView.prependToTop this
    @toggleScriptOptions 'hide'

  toggleScriptOptions: (command) ->
    #console.log command
    #@CustomScriptBuildsConfigView.hide()
    switch command
      when 'show' then this.show()
      when 'hide' then this.hide()
      else this.toggle()
    #console.log "toggle console"

  close: ->
    atom.workspaceView.trigger 'customprofilescript:close-console'

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
