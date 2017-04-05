###
Codemirror-based input cell

TODO:

 - [ ] need to merge in changes rather than just overwrite when get new changes from remote

###


{React, ReactDOM, rclass, rtypes}  = require('../smc-react')

{CodeMirrorEditor} = require('./codemirror-editor')
{CodeMirrorStatic} = require('./codemirror-static')

exports.CodeMirror = rclass
    propTypes:
        actions      : rtypes.object
        id           : rtypes.string.isRequired
        options      : rtypes.immutable.Map.isRequired
        value        : rtypes.string.isRequired
        font_size    : rtypes.number  # not explicitly used, but critical to re-render on change so Codemirror recomputes itself!
        is_focused   : rtypes.bool.isRequired
        cursors      : rtypes.immutable.Map
        complete     : rtypes.immutable.Map

    getInitialState: ->
        click_coords : undefined  # coordinates if static input was just clicked on
        last_cursor  : undefined  # last cursor position when editing

    set_click_coords: (coords) ->
        @setState(click_coords: coords)

    set_last_cursor: (pos) ->
        if @_is_mounted  # ignore unless mounted -- can still get called due to caching of cm editor
            @setState(last_cursor: pos)

    componentDidMount: ->
        @_is_mounted = true

    componentWillUnmount: ->
        @_is_mounted = false

    shouldComponentUpdate: (next) ->
        return \
            next.id           != @props.id or \
            next.options      != @props.options or \
            next.value        != @props.value or \
            next.font_size    != @props.font_size or\
            next.is_focused   != @props.is_focused or\
            next.cursors      != @props.cursors or \
            next.complete     != @props.complete

    render: ->
        full_codemirror = false
        if @props.is_focused
            full_codemirror = true
        else if @props.cursors?.size > 0
            # TODO: it is possible to render cursors with the static viewer -- **it's just more work**
            full_codemirror = true
        else if @props.options.get('lineNumbers')
            # TODO: it is possible to render line numbers with the static viewer -- **it's just more work**
            full_codemirror = true
        if full_codemirror
            <CodeMirrorEditor
                actions          = {@props.actions}
                id               = {@props.id}
                options          = {@props.options}
                value            = {@props.value}
                font_size        = {@props.font_size}
                cursors          = {@props.cursors}
                click_coords     = {@state.click_coords}
                set_click_coords = {@set_click_coords}
                set_last_cursor  = {@set_last_cursor}
                last_cursor      = {@state.last_cursor}
                is_focused       = {@props.is_focused}
                complete         = {@props.complete}
                />
        else
            <CodeMirrorStatic
                actions          = {@props.actions}
                id               = {@props.id}
                options          = {@props.options}
                value            = {@props.value}
                font_size        = {@props.font_size}
                cursors          = {@props.cursors}
                complete         = {@props.complete}
                set_click_coords = {@set_click_coords}
                />
