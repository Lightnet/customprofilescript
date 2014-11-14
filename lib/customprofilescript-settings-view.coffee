###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###

#CodeContext = require './code-context'
#grammarMap = require './grammars'

AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'

{$, $$, ScrollView, TextEditorView} = require 'atom'
{View} = require 'atom'

module.exports =
class CustomProfileScriptSettingsView extends View
  @bufferedProcess: null

  @content: ->
    @div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'toggleconsole'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'

  initialize: (@runOptions) ->
    #atom.workspaceView.prependToTop this
    #@toggleScriptOptions 'hide'
    #console.log this


  close: ->
    #atom.workspaceView.trigger 'customprofilescript:close-console'

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
