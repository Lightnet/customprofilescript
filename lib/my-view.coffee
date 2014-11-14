###

  Project Name: Custom Profile Script
  Date:2014.11.13
  Created by: Lightnet
  Link:https://github.com/Lightnet/customprofilescript
  license: MIT

  Check for more information on readme.txt file.

###

path = require 'path'
_ = require 'underscore-plus'
{$, $$, ScrollView, TextEditorView} = require 'atom'
#async = require 'async'
#CSON = require 'season'

module.exports =
class MyView extends ScrollView
  #@bufferedProcess: null

  @content: ->
    @div class: 'settings-view pane-item', tabindex: -1, =>
      @div class: 'config-menu', outlet: 'sidebar', =>
        @ul class: 'panels-menu nav nav-pills nav-stacked', outlet: 'panelMenu', =>
          @div class: 'panel-menu-separator', outlet: 'menuSeparator'
          @div class: 'editor-container settings-filter', =>
            @subview 'filterEditor', new TextEditorView(mini: true, placeholderText: 'Filter packages')
        @ul class: 'panels-packages nav nav-pills nav-stacked', outlet: 'panelPackages'
        @div class: 'button-area', =>
          @button class: 'btn btn-default icon icon-link-external', outlet: 'openDotAtom', 'Open ~/.atom'
      @div class: 'panels padded', outlet: 'panels'

  initialize: ({@uri, activePanelName}={}) ->
    super
    console.log 'initialize'
    #

  handlePackageEvents: ->

  initializePanels: ->

  afterAttach: (onDom) ->

  serialize: ->

  getPackages: ->

  addCorePanel: (name, iconName, panel) ->

  addPackagePanel: (pack) ->

  addPanel: (name, panelMenuItem, panelCreateCallback) ->

  getOrCreatePanel: (name) ->

  makePanelMenuActive: (name) ->

  focus: ->
    super

  showPanel: (name) ->

  filterPackages: ->

  removePanel: (name) ->

  getTitle: ->
    "CustomProfileScript Config"

  getIconName: ->
    "tools"

  getUri: ->
    @uri

  isEqual: (other) ->
    other instanceof MyView
