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
#link ref: https://discuss.atom.io/t/file-path-for-assets-used-in-packages/6823/2
#atom://<PACKAGE NAME>/<LOCATION>/<FILE.EXT>

#link ref:https://github.com/guscost/guscost.github.io/blob/master/spacefrack/js/etc/atom.coffee

AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'

{View, BufferedProcess, $$, $ } = require 'atom'

THREE = require './three.min'

module.exports =
class CustomProfileScriptAvatarView extends View
  @bufferedProcess: null
  scene: null #new THREE.Scene()
  camera: null # new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
  renderer: null # new THREE.WebGLRenderer();
  cube: null # new THREE Mesh
  Sheight: 320#window.innerHeight
  Swidth: 480#window.innerWidth
  bStart: true
  bPause: false
  ms: 500
  IsRenderCreated: false
  _activeButton: -1
  activeButton: 0
  offset_x:0
  offset_y:0
  pos_x = 0
  pos_y = 0
  self= @
  bUpdate:false
  bOut:true


  @content: ->
    #@element = document.createElement('div')
    #@element.classList.add('customprofilescript',  'overlay', 'from-top')
    @div class: 'customprofilescript overlay', =>
    #@div class: 'panel-heading padded heading header-view', outlet: 'AvatarHeader', => #header
      #@div id:'mymodal', class: 'overlay from-top panel', => #non header
      # style:'position: fixed;left: 250px;top: 0px;'
      @div style:'position: fixed;left: 0px;top: 0px;', outlet: 'AvatarHeader', =>
        @div class: 'panel-heading padded heading header-view', outlet: 'AvatarView', => #header
          @div class: 'block', =>
            @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'toggleconsole'
            @span class: 'heading-title', outlet: 'title'
            @span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: 'start'
            @span class: 'heading-status icon-playback-pause', outlet: 'icon_stop', click: 'pause'
            @span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: 'stop'
            @span class: 'heading-status icon-sync', outlet: 'icon_restart', click: 'restart'

            @span class: 'heading-status icon-triangle-down', outlet: '', click: 'movepanel_down'
            @span class: 'heading-status icon-triangle-left', outlet: '', click: 'movepanel_left'
            @span class: 'heading-status icon-triangle-right', outlet: '', click: 'movepanel_right'
            @span class: 'heading-status icon-triangle-up', outlet: '', click: 'movepanel_up'
          @div class: 'block', =>
            @div outlet:'renderscene'
  #constructor: (serializeState) ->
    #super
    #atom.commands.add 'atom-workspace', 'customprofilescript:timetick': -> @timetick()

  initialize: (@runOptions) ->
    AvatarHeader = @AvatarHeader
    @title.text  ' Avatar '
    # Init Threejs
    @initThreejs()
    # Bind commands
    @addbindCommands()
    #hide view
    this.hide()
    @addlisten()
    #console.log $
    #console.log @element

    #console.log @AvatarView

    #@AvatarView.mouseenter(this,@eventmouseenter)
    @AvatarView.mouseout(this,@eventmouseout)
    @AvatarView.mouseover(this,@eventmouseover)

    @AvatarView.mouseup(this,@eventmouseup)
    @AvatarView.mousedown(this,@eventmousedown)
    @AvatarView.mousemove(this,@eventmousemove)
    #console.log @element
    self = @
    #console.log testrun(false)

    self.setmodalx( atom.config.get('customprofilescript.avatarviewposx'))
    self.setmodaly( atom.config.get('customprofilescript.avatarviewposy'))


  testrun = (isprefixed) =>
    return 'test'
  #==============================================
  #div mouse events
  eventmouseenter:(e)->
    #console.log "eventmouseenter"
  eventmouseout:(e)->
    #console.log "eventmouseout"
    self.bOut = true
  eventmouseover:(e)->
    #console.log "eventmouseover"
    self.bOut = false
  eventmouseup:(e)->
    #console.log "eventmouseup"
    self.bUpdate = false
    #save settings
    atom.config.set('customprofilescript.avatarviewposx', self.getmouse_x())
    atom.config.set('customprofilescript.avatarviewposy', self.getmouse_y())

  eventmousedown:(e)->
    #console.log "eventmousedown"
    #console.log getmouse_x(false)
    self.bUpdate = true
    self.offset_x = e.offsetX
    self.offset_y = e.offsetY

  eventmousemove:(e)->
    #console.log "eventmousemove"
    #console.log e
    #console.log (e.clientX+":"+e.clientY)
    pos_x = e.clientX
    pos_y = e.clientY

    if self.bUpdate == true #update modal
      #console.log 'updating...'
      self.update_modal()
      #console.log self.update_modal()

  #==============================================
  # update modal
  update_modal:->
    #console.log 'update?'
                                #mouse    #offset of the modal position
    self.AvatarHeader.css('left',(pos_x - self.offset_x) + 'px')
    self.AvatarHeader.css('top', (pos_y - self.offset_y) + 'px')

  getmouse_x: (isprefixed) =>
    #console.log self.AvatarHeader
    x1 =  self.AvatarHeader.css('left').replace('px','')
    #x1 ='0'
    x1 = parseInt(x1)
    return x1

  getmouse_y: (isprefixed) ->
    y1 =  self.AvatarHeader.css('top').replace('px','')
    y1 = parseInt(y1)
    return y1

  setmodalx:(_x)->
    self.AvatarHeader.css('left', _x + 'px')

  setmodaly:(_y)->
    self.AvatarHeader.css('top', _y + 'px')

  movepanel_left:->
    x1 = self.getmouse_x(false) - 5
    self.setmodalx(x1)
    #console.log x1

  movepanel_right:->
    x1 =  self.getmouse_x(false) + 5
    self.setmodalx(x1)
    #console.log x1

  movepanel_up:->
    x1 = self.getmouse_y(false) - 5
    self.setmodaly(x1)
    #console.log x1

  movepanel_down:->
    y1 = self.getmouse_y(false) + 5
    self.setmodaly(y1)
    #console.log y1

  addbindCommands:->
    atom.workspaceView.command 'customprofilescript:toggleavatar', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:hideavatar', => @toggleScriptOptions 'hide'
    atom.workspaceView.command 'customprofilescript:showavatar', => @toggleScriptOptions 'show'
    #@toggleScriptOptions 'hide'
    atom.commands.add 'atom-workspace', 'customprofilescript:render': => @render()

    atom.commands.add 'atom-workspace', 'customprofilescript:startrender': => @start()
    atom.commands.add 'atom-workspace', 'customprofilescript:pauserender': => @pause()
    atom.commands.add 'atom-workspace', 'customprofilescript:stoprender': => @stop()
    atom.commands.add 'atom-workspace', 'customprofilescript:restartrender': => @restart()
    #console.log "initialize avatar?"
    #atom.workspaceView.appendToTop(this)
    #atom.workspaceView.appendToRight(this)
    #atom.workspaceView.append(this)

  addlisten:->
    #link ref : http://www.w3schools.com/jsref/dom_obj_event.asp
    #window.addEventListener("mousemove", @updateMouseState, false)
    #window.addEventListener("mousedown", @updateMouseState, false)
    #window.addEventListener("mouseup", @updateMouseState, false)

    #window.addEventListener("dragover",drawCallback = ->
      #@updateMouseState({which: 1})
    #, false)
    #window.addEventListener("dragleave",drawCallback = ->
      #@updateMouseState({which: 0})
    #,false)

  removelisten:->

  updateMouseState:(e)->
    #console.log 'move?'
    #console.log e
    @_activeButton = -1
    @activeButton = 0

    # update active button.
    #console.log e.button
    #console.log e.type
    #console.log e.which
    #activeButton = typeof e.buttons == "number" ? e.buttons : e.which
  monitorCursor: ->
    atom.workspaceView.eachEditorView (ev) =>
      ev.on 'mouse:moved', =>
        console.log "move?"

    atom.workspaceView.eachEditorView (ev) =>
      ev.on 'cursor:moved', =>
        editor = atom.workspace.getActiveTextEditor()
        console.log editor
        markers = editor.getMarkers()
        console.log markers
        #cursor = editor.getCursor()
        #cursorPos = cursor.getBufferPosition()
        #console.log cursorPos
        #for marker in markers
          #if marker.getAttributes().isDartMarker
            #range = marker.getBufferRange()

  timetick:->
    console.log 'tick'

  initThreejs:->
    #console.log @Sheight
    #console.log @Swidth

    @scene =  new THREE.Scene()
    #@camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
    @camera = new THREE.PerspectiveCamera( 75,@Swidth/@Sheight, 0.1, 1000 );
    @renderer = new THREE.WebGLRenderer();
    #@renderer.setSize( window.innerWidth, window.innerHeight );
    @renderer.setSize( @Swidth, @Sheight );

    #console.log @scene
    #console.log @camera
    #console.log @renderer

    geometry = new THREE.BoxGeometry( 1, 1, 1 );
    material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    @cube = new THREE.Mesh( geometry, material );

    #console.log @cube
    @scene.add(@cube);

    @camera.position.z = 5;

    #console.log "@renderscene"
    @renderscene.append(@renderer.domElement)

  start:->
    #console.log "start"
    @bPause = false
    if @IsRenderCreated == false
      @render()
      #console.log "render init?"
    #console.log "end start"

  pause:->
    #console.log "pause"
    @bPause = true

  stop:->
    #console.log "stop"
    #window

  restart:->
    console.log "restart"

  render:->
    @IsRenderCreated = true
    callback = @render.bind(@)
    window.requestAnimationFrame(callback, 1000 )
    if @bPause == true
      return

    #console.log('foo = ', @foo)
    #requestAnimationFrame
    #window.requestAnimationFrame( @render() );
    #console.log "render?"

    @cube.rotation.x += 0.1;
    @cube.rotation.y += 0.1;
    @renderer.render(@scene, @camera);

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
