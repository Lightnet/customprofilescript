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

{View,BufferedProcess,$$} = require 'atom'

module.exports =
class CustomProfileScriptConsoleView extends View
  @bufferedProcess: null

  @content: ->
    @div =>
      #@div class: 'overlay from-top panel', outlet: 'scriptOptionsView', => #non header

      @div class: 'panel-heading padded heading header-view', => #header
        @span class: 'heading-title', outlet: 'title'
        @span class: 'heading-status', outlet: 'status'
        @span
          class: 'heading-close icon-remove-close pull-right'
          outlet: 'closeButton'
          click: 'toggleScriptOptions'
        # Display layout and outlets
      @div class: 'block', =>
        css = 'tool-panel panel panel-bottom padding script-view
          native-key-bindings'
        @div class: css, outlet: 'script', tabindex: -1, =>
          @div class: 'panel-body padded output', outlet: 'output'

  initialize: (@runOptions) ->
    @ansiFilter = new AnsiFilter
    @title.text  'Custom Profile Script'
    @setStatus 'stop'
    @output.empty()
      # Bind commands
    atom.workspaceView.command 'customprofilescript:run', => @run()
    #atom.workspaceView.command 'customprofilescript:run-by-line-number', => @lineRun()
    #atom.workspaceView.command 'customprofilescript:close-view', => @close()
    atom.workspaceView.command 'customprofilescript:kill-process', => @stop()

    atom.workspaceView.command 'customprofilescript:msg-console', => @msgconsole()

    atom.workspaceView.command 'customprofilescript:toggle-console', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:open-console', => @toggleScriptOptions()
    atom.workspaceView.command 'customprofilescript:close-console', =>
      @toggleScriptOptions 'hide'
    atom.workspaceView.prependToTop this
    @toggleScriptOptions 'hide'

  msgconsole:->
    console.log "test"
    @output.append "test"

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

  handleError: (err) ->
    # Display error and kill process
    @title.text 'Error'
    @setStatus 'err'
    @output.append err
    #@stop()

  run: (command, extraArgs, codeContext) ->
    atom.emit 'achievement:unlock', msg: 'Homestar Runner'

    stdout = (output) => @display 'stdout', output
    stderr = (output) => @display 'stderr', output

    options =
      cwd: @getCwd()
    #args = ['help']
    args = ['cd']

    exit = (returnCode) =>
      if returnCode is 0
        @setStatus 'stop'
        console.log 'stop'
      else
        @setStatus 'err'
      console.log "Exited with #{returnCode}"

    # Run process
    @bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit
    })
    @toggleScriptOptions 'show'
    console.log @bufferedProcess

  getCwd: ->
    #if not @runOptions.workingDirectory? or @runOptions.workingDirectory is ''
      #atom.project.getPath()
    #else
      #@runOptions.workingDirectory
    atom.project.getPath()

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display 'stdout', '^C'
      @headerView.setStatus 'kill'
      @bufferedProcess.kill()

  display: (css, line) ->
    console.log line
    line = _.escape(line)
    line = @ansiFilter.toHtml(line)

    @output.append $$ ->
      @pre class: "line #{css}", =>
        @raw line
  defaultRun: ->
    #@resetView()
    #codeContext = @buildCodeContext() # Until proven otherwise
    #@start(codeContext) unless not codeContext?

  resetView: (title = 'Loading...') ->
    # Display window and load message

    # First run, create view
    atom.workspaceView.prependToBottom this unless @hasParent()

    # Close any existing process and start a new one
    @stop()

    @title.text title
    @setStatus 'start'

    # Get script view ready
    @output.empty()


  close: ->
    # Stop any running process and dismiss window
    @stop()
    @detach() if @hasParent()
