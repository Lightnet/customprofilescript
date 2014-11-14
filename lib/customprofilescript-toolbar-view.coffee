###
 Project Name: Custom Script Builds
 Link: https://github.com/Lightnet/customscriptbuilds
 License: MIT
 Information: To run typescript for server hosting for better style format flow.
 To create a simple work flow layout. For browser game or application for html.
###

#CodeContext = require './code-context'
#grammarMap = require './grammars'

AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'

{View,BufferedProcess,$$} = require 'atom'

module.exports =
class CustomProfileScriptConsoleView extends View
  @bufferedProcess: null

  @content: ->
    #@div class: 'overlay from-top panel', outlet: 'scriptOptionsView', => #non header
    @div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'toggleconsole'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'

      @span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: ''
      @span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: ''
      @span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''

      css = 'btn inline-block-tight'
      @button class: "btn #{css}", click: 'close', 'Close'

  initialize: (@runOptions) ->
    @ansiFilter = new AnsiFilter
    @title.text  'Custom Profile Script Toolbar'
    @setStatus 'stop'

    # Bind commands
    #atom.workspaceView.command 'customprofilescript:msg-console', => @msgconsole()
    atom.workspaceView.command 'customprofilescript:toggletoolbar', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:hidetoolbar', => @toggleScriptOptions 'hide'
    atom.workspaceView.command 'customprofilescript:showtoolbar', => @toggleScriptOptions 'show'
    @toggleScriptOptions 'hide'

  toggleconsole:->
    atom.workspaceView.trigger 'customprofilescript:toggle-console'

  toggleScriptOptions: (command) ->
    #console.log command
    console.log "toggle toolbar"
    #@CustomScriptBuildsConfigView.hide()
    switch command
      when 'show' then this.show()
      when 'hide' then this.hide()
      else this.toggle()
    #console.log "toggle console"

  close: ->
    this.hide()

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
